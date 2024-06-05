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
    @Published var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    @Published var nearbyButtonAlert: NearbyButtonAlert?
    @Published var isAlertPresented = false
    @Published var hasTextField = false

    @Published var farmersLoadingInProgress = false

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

    let imageSystemNameSearchButton: String
    let imageSystemNameReloadButton: String

    init(farmerService: FarmerServiceProtocol) {
        self.farmerService = farmerService
        self.imageSystemNameSearchButton = "magnifyingglass"
        self.imageSystemNameReloadButton = "arrow.clockwise"

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
        Task {
            await loadFarmers()
        }
    }

    @MainActor private func loadFarmers() async {
        do {
            farmersLoadingInProgress = true
            guard let currentUserLocation else { return }
            let farmers = try await self.farmerService.searchFarmers(around: currentUserLocation)
            var allMarkers: [Marker] = []
            for farmer in farmers.items {
                for address in farmer.addresses {
                    let marker = Marker(farmer: farmer, address: address)
                    allMarkers.append(marker)
                }
            }
            self.allMarkers = allMarkers
            farmersLoadingInProgress = false
        } catch {
            farmersLoadingInProgress = false
            nearbyButtonAlert = .loadError
        }
    }

    @MainActor private func loadFarmersWithSpecificArea() async {
        do {
            farmersLoadingInProgress = true
            guard let currentMapCameraPosition else { return }
            let farmers = try await self.farmerService.searchFarmers(around: CLLocation(latitude: currentMapCameraPosition.latitude, longitude: currentMapCameraPosition.longitude))
            var allMarkers: [Marker] = []
            for farmer in farmers.items {
                for address in farmer.addresses {
                    let marker = Marker(farmer: farmer, address: address)
                    allMarkers.append(marker)
                }
            }
            self.allMarkers = allMarkers
            farmersLoadingInProgress = false
        } catch {
            farmersLoadingInProgress = false
            nearbyButtonAlert = .noFarmerAround
        }
    }

    private func requestUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func onReloadingFarmersButtonTapped() {
        reloadingFarmers()
    }

    func onSearchAreaButtonTapped() {
        guard currentUserLocation != nil else {
            isAlertPresented = true
            hasTextField = false
            nearbyButtonAlert = .noLocation
            return
        }
        Task {
            await loadFarmersWithSpecificArea()
        }
    }

    func reloadingFarmers() {
        guard currentUserLocation != nil else {
            isAlertPresented = true
            hasTextField = false
            nearbyButtonAlert = .noLocation
            return
        }
        Task {
            await loadFarmers()
        }
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
        let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyLocation.coordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
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

    var systemImageName: String {
        return "laurel.leading"
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
        let systemImage: String
        let address: Address
        let farmer: Farmer

        init(farmer: Farmer, address: Address) {
            self.id = UUID()
            self.title = farmer.title
            self.coordinate = .init(latitude: address.latitude, longitude: address.longitude)
            self.systemImage = farmer.systemImageName
            self.address = address
            self.farmer = farmer
        }
    }
}
