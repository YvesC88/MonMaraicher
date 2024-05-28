//
//  FarmerDetailsViewModel.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 29/02/2024.
//

import MapKit
import SwiftUI

struct FarmerDetailsViewModel: Identifiable, Hashable {
    let id: UUID
    let title: String
    let phoneNumber: String?
    let phoneCallURL: URL?
    let email: String?
    let emailURL: URL?
    let distance: String
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
        self.distance = Self.formatDistance(distance: Self.distanceToAnnotation(address: marker.address))
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

    private static func distanceToAnnotation(address: Address) -> CLLocationDistance {
        guard let userLocation = CLLocationManager().location else { return 0 }
        return userLocation.distance(from: CLLocation(latitude: address.latitude, longitude: address.longitude))
    }

    private static func formatDistance(distance: CLLocationDistance) -> String {
        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitOptions = .naturalScale
        let measurement = Measurement(value: distance.rounded(), unit: UnitLength.meters)
        return measurementFormatter.string(from: measurement)
    }

    func onDirectionButtonTapped() {
        let placemark = MKPlacemark(coordinate: self.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = self.title
        mapItem.openInMaps()
    }

    func getProductsImagesNames(products: [Products]) -> [String] {
        var imagesNames: Set<String> = []
        let sortedImages = ProductsImages.allCases.sorted { $0.rawValue.count > $1.rawValue.count }
        for product in products {
            for image in sortedImages where product.name.lowercased().contains(image.rawValue) {
                imagesNames.insert(image.rawValue)
                break
            }
        }
        return Array(imagesNames)
    }

    func getScale(proxy: GeometryProxy) -> CGFloat {
        let startPoint: CGFloat = 150
        let viewFrame = proxy.frame(in: .global)
        var scale: CGFloat = 1.0
        let deltaXAnimationThreshold: CGFloat = 120
        let diffFromCenter = abs(startPoint - viewFrame.origin.x - deltaXAnimationThreshold / 2)
        if diffFromCenter < deltaXAnimationThreshold {
            scale = 1 + (deltaXAnimationThreshold - diffFromCenter) / 200
        }
        return scale
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
