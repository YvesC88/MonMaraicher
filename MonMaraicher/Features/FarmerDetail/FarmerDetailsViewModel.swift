//
//  FarmerDetailsViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 29/02/2024.
//

import MapKit

struct FarmerDetailsViewModel {

    let title: String
    let phoneNumber: String?
    let products: [Products]
    let coordinate: CLLocationCoordinate2D
    let markerSystemImageName: String
    let directionButtonTitle: String
    let address: String
    let farmerAddressesTypes: [String]
    let city: String

    init(farmer: Farmer, address: OperatorsAddresses) {
        self.title = farmer.businessName.capitalized
        self.phoneNumber = farmer.personalPhone ?? farmer.businessPhone ?? "Aucun numéro disponible"
        self.products = farmer.products
        self.coordinate = .init(latitude: address.lat, longitude: address.long)
        self.markerSystemImageName = "laurel.leading"
        self.directionButtonTitle = "Y aller"
        self.address = "\(address.place.capitalized)\n\(address.zipCode) \(address.city.capitalized)"
        self.farmerAddressesTypes = address.operatorsAddressesTypes
        self.city = address.city.capitalized
    }

    func onItineraryButtonTapped() {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        mapItem.openInMaps()
    }
}
