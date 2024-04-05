//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit
import SwiftUI

enum NearbyButtonTapped {
    case noFarmer
    case noLocation

    var title: String {
        switch self {
        case .noFarmer:
            return "Aucun maraîcher trouvé dans un rayon de "
        case .noLocation:
            return "Localisation impossible"
        }
    }

    var message: String {
        switch self {
        case .noFarmer:
            return "Vous pouvez modifier le périmètre de recherche"
        case .noLocation:
            return "Veuillez accepter la localisation dans les réglages"
        }
    }

    var buttonTitle: String {
        switch self {
        case .noFarmer:
            return "OK"
        case .noLocation:
            return "Réglages"
        }
    }
}

final class MapViewModel: ObservableObject {

    @Published var selectedFarmer: Farmer?
    @Published var allFarmers: [Farmer] = []
    @Published var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Published var isNoFarmerAlertPresented = false
    @Published var isNoLocationAlertPresented = false

    @Published var alertTitle = ""
    @Published var alertMessage = ""
    @Published var alertButtonTitle = ""

    @Published var searchScope = 0.0

    private let locationManager = CLLocationManager()
    private var currentUserLocation: CLLocation? { locationManager.location }
    private let farmerService: FarmerService

    let imageSystemNameSearchButton: String

    init(farmerService: FarmerService) {
        self.farmerService = farmerService
        self.imageSystemNameSearchButton = "magnifyingglass"
        loadFarmers()
    }

    func onViewAppear() {
        requestUserAuthorization()
    }

    private func loadFarmers() {
        DispatchQueue.main.async {
            do {
                self.allFarmers = try self.farmerService.loadFarmers(forName: "Farmers")
            } catch {
                print("Error when loading farmers: \(error)")
            }
        }
    }

    private func requestUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // TODO: Write unit tests for this method
    func onNearbyFarmerButtonTapped() {
        guard let currentUserLocation else {
            isNoLocationAlertPresented = true
            alertTitle = NearbyButtonTapped.noLocation.title
            alertMessage = NearbyButtonTapped.noLocation.message
            alertButtonTitle = NearbyButtonTapped.noLocation.buttonTitle
            return
        }
        do {
            if let nearbyFarmer = findNearbyFarmer(from: currentUserLocation) {
                let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.location.latitude,
                                                                    longitude: nearbyFarmer.location.longitude)
                let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate,
                                                            span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapCameraPosition = .region(nearbyFarmerRegion)
            } else {
                isNoFarmerAlertPresented = true
                alertTitle = NearbyButtonTapped.noFarmer.title + formatDistance(distance: searchScope)
                alertMessage = NearbyButtonTapped.noFarmer.message
                alertButtonTitle = NearbyButtonTapped.noFarmer.buttonTitle
            }
        }
    }

    func onNearbyFarmerTappedAndNoLocation() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(settingsURL)
    }

    private func findNearbyFarmer(from location: CLLocation) -> Farmer? {
        var searchScopeInKms = searchScope.inKilometers
        var nearbyFarmer: Farmer?
        for farmer in allFarmers {
            let farmerLocation = CLLocation(latitude: farmer.location.latitude, longitude: farmer.location.longitude)
            let distance = location.distance(from: farmerLocation)
            if distance < searchScopeInKms {
                searchScopeInKms = distance
                nearbyFarmer = farmer
            }
        }
        return nearbyFarmer
    }

    private func formatDistance(distance: Double) -> String {
        return String(format: "%.f km", distance)
    }
}

extension Double {
    var inKilometers: Double {
        return self * 1000
    }
}

extension Farmer {

    var title: String {
        return name.capitalized
    }

    var systemImageName: String {
        return "laurel.leading"
    }
}
