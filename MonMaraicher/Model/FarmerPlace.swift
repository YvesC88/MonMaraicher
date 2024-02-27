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
    
    static let all = [FarmerPlace(name: "Chez William", location: FarmerPlace.chezWilliam),
                      FarmerPlace(name: "Maraîchers Bio de Grabels", location: FarmerPlace.bio),
                      FarmerPlace(name: "Fred producteur", location: FarmerPlace.fred),
                      FarmerPlace(name: "Mon Maraîcher", location: FarmerPlace.maraicher),
                      FarmerPlace(name: "La ferme du Chot", location: FarmerPlace.chot)]
    
    private static let chezWilliam = Location(latitude: 43.59438738571344, longitude: 3.8856880631710875)
    private static let bio = Location(latitude: 43.654021390247834, longitude: 3.818078906825667)
    private static let fred = Location(latitude: 43.66331635156326, longitude: 3.9341394263737)
    private static let maraicher = Location(latitude: 43.594984821459704, longitude: 3.900391797826057)
    private static let chot = Location(latitude: 43.578405305924235, longitude: 3.8071850039225246)
}
