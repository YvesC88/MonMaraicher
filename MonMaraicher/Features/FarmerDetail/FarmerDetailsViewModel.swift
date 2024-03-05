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
    let address: String
    let city: String

    init(farmer: FarmerPlace) {
        self.title = farmer.name.capitalized
        self.coordinate = .init(latitude: farmer.location.latitude,
                                longitude: farmer.location.longitude)
        self.imageNames = farmer.imageNames
        self.address = Self.formatAddress(farmer.location.address).capitalized
        self.city = farmer.location.address.city.capitalized
    }

    private static func formatAddress(_ address: Address) -> String {
        let endAddress = "\(address.streetName)\n\(address.zip) \(address.city)"
        if let streetNumber = address.streetNumber {
            return "\(streetNumber) " + endAddress
        } else {
            return endAddress
        }
    }
}
