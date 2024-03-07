//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {

    @Published var selectedFarmerPlace: FarmerPlace?

    @Published var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    let allFarmerPlaces = FarmerPlace.all

    func onViewAppear() {
        requestUserAuthorization()
    }

    private func requestUserAuthorization() {
        CLLocationManager().requestWhenInUseAuthorization()
        CLLocationManager().desiredAccuracy = kCLLocationAccuracyBest
    }
}

extension FarmerPlace {

    var title: String {
        return name.capitalized
    }

    var systemImageName: String {
        return "carrot.fill"
    }
}
