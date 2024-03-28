//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {

    @Published var selectedFarmer: Farmer?
    @Published var allFarmers: [Farmer] = []
    @Published var mapCameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    private let locationManager = CLLocationManager()
    private let farmerService: FarmerService
    private var currentUserLocation: CLLocation? { locationManager.location }

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
            return print("Veuillez activer la localisation")
        }
        do {
            if let nearbyFarmer = findNearbyFarmer(from: currentUserLocation) {
                let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.location.latitude,
                                                                    longitude: nearbyFarmer.location.longitude)
                let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate,
                                                            span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
                mapCameraPosition = .region(nearbyFarmerRegion)
            } else {
                print("Aucun maraîcher trouvé à proximité")
            }
        }
    }

    private func findNearbyFarmer(from location: CLLocation) -> Farmer? {
        var searchScopeInMeters = 10_000.0
        var nearbyFarmer: Farmer?
        for farmer in allFarmers {
            let farmerLocation = CLLocation(latitude: farmer.location.latitude, longitude: farmer.location.longitude)
            let distance = location.distance(from: farmerLocation)
            if distance < searchScopeInMeters {
                searchScopeInMeters = distance
                nearbyFarmer = farmer
            }
        }
        return nearbyFarmer
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
