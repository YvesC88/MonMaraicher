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

    init() {
        getFarmers()
    }

    func onViewAppear() {
        requestUserAuthorization()
    }

    private func getFarmers() {
        let mapViewService = MapViewService()
        mapViewService.loadFarmers()
        allFarmers = mapViewService.allFarmers
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
