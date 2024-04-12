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
    let markerSystemImageName: String
    let directionButtonTitle: String
    let address: String
    let city: String

    init(farmer: Farmer) {
        self.title = farmer.raisonSociale.capitalized
        self.coordinate = CLLocationCoordinate2D(latitude: farmer.adressesOperateurs.first?.lat ?? 0.0, longitude: farmer.adressesOperateurs.first?.long ?? 0.0)
        self.markerSystemImageName = "laurel.leading"
        self.directionButtonTitle = "Y aller"
        self.address = "\(farmer.adressesOperateurs.first?.lieu.capitalized ?? "")\n\(farmer.adressesOperateurs.first?.codePostal ?? "") \(farmer.adressesOperateurs.first?.ville.capitalized ?? "")"
        self.city = farmer.adressesOperateurs.first?.ville.capitalized ?? ""
    }

    func onItineraryButtonTapped() {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        mapItem.openInMaps()
    }
}
