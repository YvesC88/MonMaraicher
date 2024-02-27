//
//  FarmerPlace.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 24/02/2024.
//

import Foundation

struct FarmerPlace: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let location: Location
    
    static let all = [FarmerPlace(name: "Chez William", location: FarmerPlace.applePark1),
                      FarmerPlace(name: "Maraîchers Bio de Grabels", location: FarmerPlace.applePark2),
                      FarmerPlace(name: "Fred producteur", location: FarmerPlace.applePark3),
                      FarmerPlace(name: "Mon Maraîcher", location: FarmerPlace.applePark4),
                      FarmerPlace(name: "La ferme du Chot", location: FarmerPlace.applePark5)]
    
    private static let chezWilliam = Location(latitude: 43.59438738571344, longitude: 3.8856880631710875)
    private static let bio = Location(latitude: 43.654021390247834, longitude: 3.818078906825667)
    private static let fred = Location(latitude: 43.66331635156326, longitude: 3.9341394263737)
    private static let maraicher = Location(latitude: 43.594984821459704, longitude: 3.900391797826057)
    private static let chot = Location(latitude: 43.578405305924235, longitude: 3.8071850039225246)
    
    private static let applePark1 = Location(latitude: 37.33771487954408, longitude: -122.01871382213936)
    private static let applePark2 = Location(latitude: 37.34320749025098, longitude: -122.00085869214455)
    private static let applePark3 = Location(latitude: 37.320788995175214, longitude: -122.02416356085007)
    private static let applePark4 = Location(latitude: 37.32238963337884, longitude: -121.98463768108974)
    private static let applePark5 = Location(latitude: 37.34986124022765, longitude: -122.01214762927336)
}
