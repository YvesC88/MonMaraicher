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

    // TODO: Write unit tests for this method
    func onNearbyFarmerButtonTapped() {
        do {
            let nearbyFarmer = try findNearbyFarmer()
            let nearbyFarmerCoordinate = CLLocationCoordinate2D(latitude: nearbyFarmer.location.latitude,
                                                                longitude: nearbyFarmer.location.longitude)
            let nearbyFarmerRegion = MKCoordinateRegion(center: nearbyFarmerCoordinate,
                                                        span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapCameraPosition = .region(nearbyFarmerRegion)
        } catch SearchingFarmerError.noFarmerFound {
            print("Aucun maraîcher trouvé à proximité")
        } catch SearchingFarmerError.userLocationNoFound {
            // TODO: Request to the user to go to the settings
            print("Veuillez accepter la localisation")
        } catch {
            print("Une erreur est survenue lors de la recherche d'un maraîcher")
        }
    }

    // TODO: Write unit tests for this method
    func findNearbyFarmer() throws -> Farmer {
        var searchScopeInMeters = 10_000.0
        var nearbyFarmer: Farmer?
        guard let userLocation = CLLocationManager().location else { throw SearchingFarmerError.userLocationNoFound }
        for farmer in allFarmers {
            let farmerLocation = CLLocation(latitude: farmer.location.latitude, longitude: farmer.location.longitude)
            let distance = userLocation.distance(from: farmerLocation)
            if distance < searchScopeInMeters {
                searchScopeInMeters = distance
                nearbyFarmer = farmer
            }
        }
        guard let nearbyFarmer = nearbyFarmer else { throw SearchingFarmerError.noFarmerFound }
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
