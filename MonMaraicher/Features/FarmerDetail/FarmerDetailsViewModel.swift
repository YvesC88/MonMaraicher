//
//  FarmerDetailsViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 29/02/2024.
//

import MapKit

struct FarmerDetailsViewModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let phoneNumber: String?
    let phoneCallURL: URL?
    let email: String?
    let emailURL: URL?
    let products: [Products]
    let websites: [Websites]
    let coordinate: CLLocationCoordinate2D
    let address: String
    let farmerAddressesTypes: [String]
    let city: String

    let markerSystemImageName: String
    let directionButtonImageSystemName: String
    let phoneButtonImageSystemName: String
    let emailButtonImageSystemName: String

    init(marker: MapViewModel.Marker) {
        self.id = marker.id
        self.title = marker.title
        self.phoneNumber = marker.farmer.businessPhone ?? marker.farmer.personalPhone
        self.phoneCallURL = URL(string: "tel:\(phoneNumber ?? "")")
        self.email = marker.farmer.email
        self.emailURL = URL(string: "mailto:\(email ?? "")")
        self.products = marker.farmer.products
        self.websites = marker.farmer.websites
        self.coordinate = marker.coordinate
        self.address = "\(marker.address.place.capitalized)\n\(marker.address.zipCode) \(marker.address.city.capitalized)"
        self.farmerAddressesTypes = marker.address.farmerAddressesTypes
        self.city = marker.address.city.capitalized
        self.markerSystemImageName = "laurel.leading"
        self.directionButtonImageSystemName = "map.fill"
        self.phoneButtonImageSystemName = "phone.fill"
        self.emailButtonImageSystemName = "envelope.fill"
    }

    func formatWebsite(_ website: Websites) -> String {
        return "[\(website.websiteType.name)](\(website.url))"
    }

    func onDirectionButtonTapped() {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        mapItem.openInMaps()
    }
}

extension CLLocationCoordinate2D: Hashable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }
}
