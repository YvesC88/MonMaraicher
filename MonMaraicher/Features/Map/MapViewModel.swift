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

    @Published var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    private let farmerService: FarmerService

    init(farmerServive: FarmerService) {
        self.farmerService = farmerServive
        // TODO: create a units tests for loadFarmers on another PR
        loadFarmers()
    }

    func onViewAppear() {
        requestUserAuthorization()
    }

    private func loadFarmers() {
        DispatchQueue.main.async {
            do {
                self.allFarmers = try self.farmerService.loadFarmers()
            } catch {
                print("Error when loading farmers: \(error)")
            }
        }
    }

    private func requestUserAuthorization() {
        CLLocationManager().requestWhenInUseAuthorization()
        CLLocationManager().desiredAccuracy = kCLLocationAccuracyBest
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
