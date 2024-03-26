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

    private let locationMangager: CLLocationManager = .init()
    private var lastUserLocation: CLLocation? { locationMangager.location }
    private let farmerService: FarmerServiceProtocol

    let imageSystemNameSearchButton: String

    init(farmerService: FarmerServiceProtocol) {
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
        locationMangager.requestWhenInUseAuthorization()
        locationMangager.desiredAccuracy = kCLLocationAccuracyBest
    }

    // TODO: Write unit tests for this method
    func onNearbyFarmerButtonTapped() {
        guard let lastUserLocation else {
            return // handle error if needed: Dire au user que la location est required: "Active la loc"
        }
        if let nearbyFarmer = findNearbyFarmer(from: lastUserLocation) {
            let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.location.latitude,
                                                                longitude: nearbyFarmer.location.longitude)
            let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate,
                                                        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapCameraPosition = .region(nearbyFarmerRegion)
        } else {
            // Display pas de farmer trouve
        }
    }

    // TODO: Write unit tests for this method
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

extension MapViewModel {

    enum SearchingFarmerError: LocalizedError {
        case noFarmerFound
        case userLocationNoFound
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
