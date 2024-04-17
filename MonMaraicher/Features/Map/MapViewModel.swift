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

    @Published var selectedAddress: OperatorsAddresses?
    @Published var allFarmers: [Farmer] = []
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
            self.allFarmers = farmers.items
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
        let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.lat, longitude: nearbyFarmer.long)
        let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate, span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapCameraPosition = .region(nearbyFarmerRegion)
    }

    func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }

    private func findNearbyAddress(from location: CLLocation) -> OperatorsAddresses? {
        var searchScopeInKms = searchScope.inKilometers
        var farmerAddress: OperatorsAddresses?
        for farmer in allFarmers {
            for address in farmer.operatorsAddresses {
                let farmerLocation = CLLocation(latitude: address.lat, longitude: address.long)
                let distance = location.distance(from: farmerLocation)
                if distance < searchScopeInKms {
                    searchScopeInKms = distance
                    farmerAddress = address
                }
            }
        }
        return farmerAddress
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
