//
//  FarmerDetailsViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 29/02/2024.
//

import MapKit

struct FarmerDetailsViewModel {

    let title: String
    let coordinate: CLLocationCoordinate2D
    let imageNames: [String]
    let city: String

    init(farmer: FarmerPlace) {
        self.title = farmer.name
        self.coordinate = .init(latitude: farmer.location.latitude,
                                longitude: farmer.location.longitude)
        self.imageNames = farmer.imageNames
        self.city = farmer.location.city
    }
}
