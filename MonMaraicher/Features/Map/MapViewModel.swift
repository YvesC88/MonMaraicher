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

    func onNearbyFarmerButtonTapped() {
        do {
            if let nearbyFarmer = try searchNearbyFarmer() {
                let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.location.latitude,
                                                                    longitude: nearbyFarmer.location.longitude)
                let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate,
                                                            span: self.nearbyFarmerSpan)
                mapCameraPosition = .region(nearbyFarmerRegion)
            }
        } catch {
            print("Aucun maraîcher trouvé à proximité")
        }
    }

    private func searchNearbyFarmer() throws -> Farmer? {
        var maxSearchDistance = 10_000.0
        var nearbyFarmer: Farmer?
        guard let userLocation = CLLocationManager().location else { return nil }
        for farmer in allFarmers {
            let distance = userLocation.distance(from: .init(latitude: farmer.location.latitude, longitude: farmer.location.longitude))
            if distance < maxSearchDistance {
                maxSearchDistance = distance
                nearbyFarmer = farmer
            }
        }
        return nearbyFarmer
    }
}

extension MapViewModel {

    enum Error: Swift.Error {
        case noFarmer
    }

    var nearbyButtonTitle: String {
        return "Maraîcher à proximité"
    }

    var systemImageName: String {
        return "location.fill"
    }

    var nearbyFarmerSpan: MKCoordinateSpan {
        return .init(latitudeDelta: 0.01, longitudeDelta: 0.01)
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
