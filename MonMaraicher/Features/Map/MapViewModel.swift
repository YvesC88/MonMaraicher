//
//  MapViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit
import SwiftUI

final class MapViewModel: ObservableObject {

    @Published var userPosition: MapCameraPosition = .userLocation(fallback: .automatic)

    @Published var selectedFarmerPlace: FarmerPlace?

    let allFarmerPlaces = FarmerPlace.all

    func onViewAppear() {
        requestUserAuthorization()
    }

    private func requestUserAuthorization() {
        CLLocationManager().requestWhenInUseAuthorization()
    }
}
