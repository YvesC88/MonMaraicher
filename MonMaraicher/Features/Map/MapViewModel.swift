//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit
import Combine
import SwiftUI

final class MapViewModel: ObservableObject {

    @Published var farmerDetailsViewModel: FarmerDetailsViewModel?
    @Published var selectedMarker: Marker?
    @Published var allMarkers: [Marker] = []
    @Published var filteredMarkers: [Marker] = []
    @Published var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    @Published var nearbyButtonAlert: NearbyButtonAlert?
    @Published var isAlertPresented = false
    @Published var hasTextField = false

    @Published var farmersLoadingInProgress = false
    @Published var isFilterViewVisible = false

    @Published var searchScope = 5.0

    @Published var currentMapCameraPosition: CLLocationCoordinate2D?

    private let locationManager = CLLocationManager()
    private var currentUserLocation: CLLocation? { locationManager.location }
    private let measurementFormatter = MeasurementFormatter()
    private var formattedDistance: String {
        measurementFormatter.string(from: Measurement(value: searchScope, unit: UnitLength.kilometers))
    }
    var hasUserAcceptedLocation: Bool { return currentUserLocation != nil }
    private let farmerService: FarmerServiceProtocol
    private var timer = Timer()

    let imageSystemNameSearchButton: String
    let imageSystemNameReloadButton: String
    var selectedCategories: Set<String>

    init(farmerService: FarmerServiceProtocol) {
        self.farmerService = farmerService
        self.imageSystemNameSearchButton = "magnifyingglass"
        self.imageSystemNameReloadButton = "arrow.clockwise"
        self.selectedCategories = []

        $nearbyButtonAlert
            .map { alertType in
                alertType != nil
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isAlertPresented)

        $selectedMarker
            .map { marker in
                guard let marker else { return nil }
                return FarmerDetailsViewModel(marker: marker)
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$farmerDetailsViewModel)
    }

    func onViewAppear() {
        requestUserAuthorization()
        guard let currentUserLocation else { return }
        Task {
            await loadFarmers(with: currentUserLocation, errorType: .loadError)
            DispatchQueue.main.async {
                self.applyFilter(for: self.selectedCategories)
            }
        }
    }

    func deselectAnnotation() {
        selectedMarker = nil
    }

    @MainActor private func loadFarmers(with location: CLLocation, errorType: NearbyButtonAlert) async {
        do {
            farmersLoadingInProgress = true
            let farmers = try await self.farmerService.searchFarmers(around: location)
            allMarkers = farmers.items.flatMap { farmer in
                farmer.addresses.filter { !$0.farmerAddressesTypes.contains("Siège social") || $0.farmerAddressesTypes.count >= 2 }
                    .map { Marker(farmer: farmer, address: $0) }
            }
            filteredMarkers = allMarkers
            farmersLoadingInProgress = false
        } catch {
            farmersLoadingInProgress = false
            nearbyButtonAlert = errorType
        }
    }

    private func requestUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func displayAnErrorIfNoUserLocation() {
        if currentUserLocation == nil {
            isAlertPresented = true
            hasTextField = false
            nearbyButtonAlert = .noLocation
        }
    }

    @MainActor private func whenMapCameraPositionMove(position: CLLocationCoordinate2D) {
        displayAnErrorIfNoUserLocation()
        let currentLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
        Task {
            await loadFarmers(with: currentLocation, errorType: .noFarmerAround)
            applyFilter(for: self.selectedCategories)
        }
    }

    func reloadingFarmers() {
        displayAnErrorIfNoUserLocation()
        guard let currentMapCameraPosition else { return }
        let currentLocation = CLLocation(latitude: currentMapCameraPosition.latitude, longitude: currentMapCameraPosition.longitude)
        Task {
            await loadFarmers(with: currentLocation, errorType: .loadError)
            applyFilter(for: self.selectedCategories)
        }
    }

    func onFilterProductsButtonTapped(by category: String) {
        if selectedCategories.contains(category) {
            selectedCategories.remove(category)
        } else {
            selectedCategories.insert(category)
        }
        applyFilter(for: selectedCategories)
    }

    private func applyFilter(for categories: Set<String>) {
        guard !categories.isEmpty else {
            allMarkers = filteredMarkers
            return
        }
        allMarkers = filteredMarkers.filter { marker in
            categories.allSatisfy { category in
                guard let productCategory = allProductsCategories.first(where: { $0.name == category }) else {
                    return false
                }
                let productsInCategory = productCategory.products
                return marker.farmer.products.contains { product in
                    productsInCategory.contains { productInCategory in
                        product.name.localizedCaseInsensitiveContains(productInCategory.rawValue)
                    }
                }
            }
        }
    }

    func focusUserLocation() {
        displayAnErrorIfNoUserLocation()
        guard let currentUserLocation else { return }
        mapCameraPosition = .region(MKCoordinateRegion(center: currentUserLocation.coordinate, span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }

    // TODO: Write unit tests for this method
    func onNearbyFarmerButtonTapped() {
        guard let currentUserLocation else {
            isAlertPresented = true
            hasTextField = false
            nearbyButtonAlert = .noLocation
            return
        }
        guard let nearbyLocation = findNearbyLocation(from: currentUserLocation) else {
            isAlertPresented = true
            hasTextField = true
            nearbyButtonAlert = .noFarmer(formattedDistance)
            return
        }
        let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyLocation.coordinate, span: .init(latitudeDelta: 0.02, longitudeDelta: 0.02))
        mapCameraPosition = .region(nearbyFarmerRegion)
    }

    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }

    private func findNearbyLocation(from location: CLLocation) -> CLLocation? {
        var searchScopeInKms = searchScope.inKilometers
        var nearbyLocation: CLLocation?
        for marker in allMarkers {
            let farmerLocation = CLLocation(latitude: marker.coordinate.latitude, longitude: marker.coordinate.longitude)
            let distance = location.distance(from: farmerLocation)
            if distance < searchScopeInKms {
                searchScopeInKms = distance
                nearbyLocation = farmerLocation
            }
        }
        return nearbyLocation
    }

    func onMapCameraChange(currentMapCameraPosition: CLLocationCoordinate2D) {
        timer.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.whenMapCameraPositionMove(position: currentMapCameraPosition)
            }
        }
    }
}

extension Double {

    var inKilometers: Double {
        return self * 1000
    }
}

extension Farmer {

    var title: String {
        return businessName.capitalized
    }

    var imageName: String {
        return "farmerIcon"
    }
}

extension MapViewModel {

    enum NearbyButtonAlert: LocalizedError {
        case noFarmer(String)
        case noLocation
        case noFarmerAround
        case loadError

        var errorDescription: String? {
            switch self {
            case .noFarmer(let distance):
                return "Aucun maraîcher trouvé dans un rayon de \(distance)"
            case .noLocation:
                return "Localisation impossible"
            case .noFarmerAround:
                return "Aucun maraîcher trouvé dans cette zone"
            case .loadError:
                return "Il semblerait qu'une erreur s'est produite"
            }
        }

        var message: String {
            switch self {
            case .noFarmer:
                return "Vous pouvez entrer une nouvelle distance en km pour élargir votre recherche"
            case .noLocation:
                return "Merci d'accepter la localisation de l'application dans les réglages"
            case .noFarmerAround:
                return "Veuillez réessayer ailleurs"
            case .loadError:
                return "Veuillez réessayer"
            }
        }

        var textFieldTitle: String? {
            switch self {
            case .noFarmer:
                return "Distance en km"
            case .noLocation:
                return nil
            case .noFarmerAround:
                return nil
            case .loadError:
                return nil
            }
        }

        var confirmButtonTitle: String {
            switch self {
            case .noFarmer:
                return "OK"
            case .noLocation:
                return "Réglages"
            case .noFarmerAround:
                return "OK"
            case .loadError:
                return "OK"
            }
        }

        var cancelButtonTitle: String? {
            switch self {
            case .noFarmer:
                return nil
            case .noLocation:
                return "Annuler"
            case .noFarmerAround:
                return nil
            case .loadError:
                return nil
            }
        }
    }
}

extension MapViewModel {

    struct Marker: Identifiable, Hashable {

        let id: UUID
        let title: String
        let coordinate: CLLocationCoordinate2D
        let image: String
        let address: Address
        let farmer: Farmer

        init(farmer: Farmer, address: Address) {
            self.id = UUID()
            self.title = farmer.title
            self.coordinate = .init(latitude: address.latitude, longitude: address.longitude)
            self.image = farmer.imageName
            self.address = address
            self.farmer = farmer
        }
    }
}
