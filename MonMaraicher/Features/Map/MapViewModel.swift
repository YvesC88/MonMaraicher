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

    private let farmerService: FarmerService

    init(farmerService: FarmerService) {
        self.farmerService = farmerService
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
        CLLocationManager().requestWhenInUseAuthorization()
        CLLocationManager().desiredAccuracy = kCLLocationAccuracyBest
    }

    func onButtonTapped() {
        if let nearbyFarmer = findNearbyFarmer() {
            mapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: nearbyFarmer.location.latitude, longitude: nearbyFarmer.location.longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        } else {
            // TODO: request to the user to invite them to accept the location
        }
    }

    private func findNearbyFarmer() -> Farmer? {
        var nearbyDistance = Double.infinity
        if let userPosition = CLLocationManager().location {
            for farmer in allFarmers {
                let distance = userPosition.distance(from: CLLocation(latitude: farmer.location.latitude, longitude: farmer.location.longitude))
                if distance < nearbyDistance {
                    nearbyDistance = distance
                    selectedFarmer = farmer
                }
            }
        }
        return selectedFarmer
    }
}

extension Farmer {

    var title: String {
        return name.capitalized
    }

    var systemImageName: String {
        return "carrot.fill"
    }
}
