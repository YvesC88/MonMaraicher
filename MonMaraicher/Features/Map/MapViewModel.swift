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

    @Published var searchScope = 5.0

    private let locationManager = CLLocationManager()
    private var currentUserLocation: CLLocation? { locationManager.location }
    private let measurementFormatter = MeasurementFormatter()
    private var formattedDistance: String {
        measurementFormatter.string(from: Measurement(value: searchScope, unit: UnitLength.kilometers))
    }
    private let farmerService: FarmerService

    let imageSystemNameSearchButton: String

    init(farmerService: FarmerService) {
        self.farmerService = farmerService
        self.imageSystemNameSearchButton = "magnifyingglass"

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
            let farmers = try await self.farmerService.loadFarmers()
            var allMarkers: [Marker] = []
            for farmer in farmers.items {
                for address in farmer.addresses {
                    let marker = Marker(farmer: farmer, address: address)
                    allMarkers.append(marker)
                }
            }
            self.allMarkers = allMarkers
        } catch {
            print("Error when loading farmers: \(error)")
        }
    }

    private func requestUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // TODO: Write unit tests for this method
    func onNearbyFarmerButtonTapped() {
        guard let currentUserLocation else {
            isAlertPresented = true
            hasTextField = false
            nearbyButtonAlert = .noLocation
            return
        }
        guard let nearbyFarmer = findNearbyAddress(from: currentUserLocation) else {
            isAlertPresented = true
            hasTextField = true
            nearbyButtonAlert = .noFarmer(formattedDistance)
            return
        }
        let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.latitude, longitude: nearbyFarmer.longitude)
        let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapCameraPosition = .region(nearbyFarmerRegion)
    }

    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }

    private func findNearbyAddress(from location: CLLocation) -> Address? {
        var searchScopeInKms = searchScope.inKilometers
        var markerAddress: Address?
        for marker in allMarkers {
            for address in marker.farmer.addresses {
                let farmerLocation = CLLocation(latitude: address.latitude, longitude: address.longitude)
                let distance = location.distance(from: farmerLocation)
                if distance < searchScopeInKms {
                    searchScopeInKms = distance
                    markerAddress = address
                }
            }
        }
        return markerAddress
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

        var errorDescription: String? {
            switch self {
            case .noFarmer(let distance):
                return "Aucun maraîcher trouvé dans un rayon de \(distance)"
            case .noLocation:
                return "Localisation impossible"
            }
        }

        var message: String {
            switch self {
            case .noFarmer:
                return "Vous pouvez entrer une nouvelle distance en km pour élargir votre recherche"
            case .noLocation:
                return "Merci d'accepter la localisation de l'application dans les réglages"
            }
        }

        var textFieldTitle: String? {
            switch self {
            case .noFarmer:
                return "Distance en km"
            case .noLocation:
                return nil
            }
        }

        var confirmButtonTitle: String {
            switch self {
            case .noFarmer:
                return "OK"
            case .noLocation:
                return "Réglages"
            }
        }

        var cancelButtonTitle: String? {
            switch self {
            case .noFarmer:
                return nil
            case .noLocation:
                return "Annuler"
            }
        }
    }
}
extension MapViewModel {

    struct Marker: Identifiable, Hashable {

        let id: UUID
        let title: String
        let address: Address
        let farmer: Farmer

        init(farmer: Farmer, address: Address) {
            self.id = UUID()
            self.title = farmer.title
            self.address = address
            self.farmer = farmer
        }

        static func == (lhs: Self, rhs: Self) -> Bool {
            return lhs.id == rhs.id && lhs.address == rhs.address
        }
    }
}
