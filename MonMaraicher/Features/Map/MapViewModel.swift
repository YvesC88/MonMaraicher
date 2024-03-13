//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {

    @Published var selectedFarmerPlace: Farmer?

    @Published var allFarmerPlaces: [Farmer] = []

    @Published var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    init() {
        readJsonFarmers()
    }

    func onViewAppear() {
        requestUserAuthorization()
    }

    private func readJsonFarmers() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            if let bundlePath = Bundle.main.path(forResource: "FarmersPlaces", ofType: "json"),
               let farmerJson = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let farmers = try decoder.decode(FarmersPlaces.self, from: farmerJson)
                allFarmerPlaces = farmers.farmers
            }
        } catch {
            print("Error decoding: \(error)")
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
