//
//  Place.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import MapKit

struct Place: Identifiable {
    let id = UUID()
    let title: String
    let coordinate: CLLocationCoordinate2D
}

let placeList = [Place(title: "Chez William", coordinate: .chezWilliam),
                 Place(title: "Maraîchers Bio de Grabels", coordinate: .bio),
                 Place(title: "Fred producteur", coordinate: .fred),
                 Place(title: "Mon Maraîcher", coordinate: .maraicher),
                 Place(title: "La ferme du Chot", coordinate: .chot)
                 ]


extension CLLocationCoordinate2D {
    static let chezWilliam = CLLocationCoordinate2D(latitude: 43.59438738571344, longitude: 3.8856880631710875)
    static let bio = CLLocationCoordinate2D(latitude: 43.654021390247834, longitude: 3.818078906825667)
    static let fred = CLLocationCoordinate2D(latitude: 43.66331635156326, longitude: 3.9341394263737)
    static let maraicher = CLLocationCoordinate2D(latitude: 43.594984821459704, longitude: 3.900391797826057)
    static let chot = CLLocationCoordinate2D(latitude: 43.578405305924235, longitude: 3.8071850039225246)
}
