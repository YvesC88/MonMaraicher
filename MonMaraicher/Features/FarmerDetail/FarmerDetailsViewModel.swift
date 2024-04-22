//
//  FarmerDetailsViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 29/02/2024.
//

import MapKit

struct SelectedMarker: Identifiable, Hashable {

    let id: Int
    let title: String
    let address: Addresses
    let farmer: Farmer

    init(farmer: Farmer) {
        self.id = farmer.id
        self.title = farmer.title
        self.address = farmer.addresses.first!
        self.farmer = farmer
    }
}

struct FarmerDetailsViewModel: Identifiable, Hashable {
    let id: Int
    let title: String
    let phoneNumber: String?
    let products: [Products]
    let coordinate: CLLocationCoordinate2D
    let markerSystemImageName: String
    let directionButtonTitle: String
    let address: String
    let farmerAddressesTypes: [String]
    let city: String

    init(marker: SelectedMarker) {
        self.id = marker.id
        self.title = marker.title
        self.phoneNumber = marker.farmer.personalPhone ?? marker.farmer.businessPhone ?? "Aucun numéro disponible"
        self.products = marker.farmer.products
        self.coordinate = .init(latitude: marker.address.latitude, longitude: marker.address.longitude)
        self.markerSystemImageName = "laurel.leading"
        self.directionButtonTitle = "Y aller"
        self.address = "\(marker.address.place.capitalized)\n\(marker.address.zipCode)\(marker.address.city.capitalized)"
        self.farmerAddressesTypes = marker.address.farmerAddressesTypes
        self.city = marker.address.city.capitalized
    }

    func onItineraryButtonTapped() {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        mapItem.openInMaps()
    }
}

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
