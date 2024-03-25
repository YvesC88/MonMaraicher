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
        CLLocationManager().requestWhenInUseAuthorization()
        CLLocationManager().desiredAccuracy = kCLLocationAccuracyBest
    }

    func onNearbyFarmerButtonTapped() {
        do {
            let nearbyFarmer = try searchingFarmer()
            let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.location.latitude,
                                                                longitude: nearbyFarmer.location.longitude)
            let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate,
                                                        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapCameraPosition = .region(nearbyFarmerRegion)
        } catch SearchingFarmer.noFarmerFound {
            print("Aucun maraîcher trouvé à proximité")
        } catch UserLocation.noLocation {
            // TODO: request to go to settings
            print("Veuillez accepté la localisation")
        } catch {
            print("Une erreur est survenue lors de la recherche d'un maraîcher")
        }
    }

    func searchingFarmer() throws -> Farmer {
        var maxSearchDistance = 10_000.0
        var nearbyFarmer: Farmer?
        guard let userLocation = CLLocationManager().location else { throw UserLocation.noLocation }
        for farmer in allFarmers {
            let farmerLocation = CLLocation(latitude: farmer.location.latitude, longitude: farmer.location.longitude)
            let distance = userLocation.distance(from: farmerLocation)
            if distance < maxSearchDistance {
                maxSearchDistance = distance
                nearbyFarmer = farmer
            }
        }
        guard let nearbyFarmer = nearbyFarmer else { throw SearchingFarmer.noFarmerFound }
        return nearbyFarmer
    }
}

extension MapViewModel {

    enum SearchingFarmer: Error {
        case noFarmerFound
    }

    enum UserLocation: Error {
        case noLocation
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
