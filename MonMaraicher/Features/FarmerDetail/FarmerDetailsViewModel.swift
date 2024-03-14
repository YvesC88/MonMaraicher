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
    let farmerImages: [String]
    let markerSystemImageName: String
    let directionButtonTitle: String
    let address: String
    let city: String

    init(farmer: Farmer) {
        self.title = farmer.name.capitalized
        self.coordinate = .init(latitude: farmer.location.latitude,
                                longitude: farmer.location.longitude)
        self.farmerImages = [farmer.images.farmer1,
                           farmer.images.farmer2,
                           farmer.images.farmer3,
                           farmer.images.farmer4,
                           farmer.images.farmer5,
                           farmer.images.farmer6]
        self.address = Self.formatAddress(farmer.location.address).capitalized
        self.city = farmer.location.address.city.capitalized
        self.markerSystemImageName = "carrot.fill"
        self.directionButtonTitle = "Y aller"
    }

    private static func formatAddress(_ address: Address) -> String {
        let endAddress = "\(address.streetName)\n\(address.zipCode) \(address.city)"
        if let streetNumber = address.streetNumber {
            return "\(streetNumber) " + endAddress
        } else {
            return endAddress
        }
    }

    func onItineraryButtonTapped() {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        mapItem.openInMaps()
    }
}
