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
    let productions: [Productions]
    let coordinate: CLLocationCoordinate2D
    let markerSystemImageName: String
    let directionButtonTitle: String
    let address: String
    let typeAddress: [String]
    let city: String

    init(farmer: Farmer, address: AdressesOperateurs) {
        self.title = farmer.raisonSociale.capitalized
        self.phoneNumber = farmer.telephone ?? farmer.telephoneCommerciale ?? "Aucun numéro disponible"
        self.productions = farmer.productions
        self.coordinate = .init(latitude: address.lat, longitude: address.long)
        self.markerSystemImageName = "laurel.leading"
        self.directionButtonTitle = "Y aller"
        self.address = "\(address.lieu.capitalized)\n\(address.codePostal) \(address.ville.capitalized)"
        self.typeAddress = address.typeAdresseOperateurs
        self.city = address.ville.capitalized
    }

    func onItineraryButtonTapped() {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        mapItem.openInMaps()
    }
}
