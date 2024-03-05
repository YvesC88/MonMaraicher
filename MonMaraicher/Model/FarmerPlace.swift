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
    let imageNames: [String]

    static let all = [FarmerPlace(name: "chez william", location: FarmerPlace.applePark1, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "maraîchers bio de grabels", location: FarmerPlace.applePark2, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "fred producteur", location: FarmerPlace.applePark3, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "mon maraîcher", location: FarmerPlace.applePark4, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "la ferme du chot", location: FarmerPlace.applePark5, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "chez william", location: FarmerPlace.chezWilliam, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "maraîchers bio de grabels", location: FarmerPlace.bio, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "fred producteur", location: FarmerPlace.fred, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "mon maraîcher", location: FarmerPlace.maraicher, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"]),
                      FarmerPlace(name: "la ferme du chot", location: FarmerPlace.chot, imageNames: ["farmer1", "farmer2", "farmer3", "farmer4", "farmer5", "farmer6"])
    ]

    private static let chezWilliam = Location(
        latitude: 43.59438738571344,
        longitude: 3.8856880631710875,
        address: Address(streetNumber: 775,
                         streetName: "avenue du maréchal leclerc",
                         zip: 34000,
                         city: "montpellier")
    )
    private static let bio = Location(
        latitude: 43.654021390247834,
        longitude: 3.818078906825667,
        address: Address(streetNumber: nil,
                         streetName: "chemin du redonnel",
                         zip: 34790,
                         city: "grabels")
    )
    private static let fred = Location(
        latitude: 43.66331635156326,
        longitude: 3.9341394263737,
        address: Address(streetNumber: nil,
                         streetName: "D65",
                         zip: 34920,
                         city: "le crès")
    )
    private static let maraicher = Location(
        latitude: 43.594984821459704,
        longitude: 3.900391797826057,
        address: Address(streetNumber: nil,
                         streetName: "rue de la rauze",
                         zip: 34070,
                         city: "montpellier")
    )
    private static let chot = Location(
        latitude: 43.578405305924235,
        longitude: 3.8071850039225246,
        address: Address(streetNumber: nil,
                         streetName: "D5E3",
                         zip: 34880,
                         city: "lavérune")
    )

    private static let applePark1 = Location(
        latitude: 37.33771487954408,
        longitude: -122.01871382213936,
        address: Address(streetNumber: 775,
                         streetName: "avenue du maréchal leclerc",
                         zip: 34000,
                         city: "montpellier")
    )
    private static let applePark2 = Location(
        latitude: 37.34320749025098,
        longitude: -122.00085869214455,
        address: Address(streetNumber: nil,
                         streetName: "chemin du redonnel",
                         zip: 34790,
                         city: "grabels")
    )
    private static let applePark3 = Location(
        latitude: 37.320788995175214,
        longitude: -122.02416356085007,
        address: Address(streetNumber: nil,
                         streetName: "D65",
                         zip: 34920,
                         city: "le crès")
    )
    private static let applePark4 = Location(
        latitude: 37.32238963337884,
        longitude: -121.98463768108974,
        address: Address(streetNumber: 139,
                         streetName: "rue de la rauze",
                         zip: 34070,
                         city: "montpellier")
    )
    private static let applePark5 = Location(
        latitude: 37.34986124022765,
        longitude: -122.01214762927336,
        address: Address(streetNumber: nil,
                         streetName: "D5E3",
                         zip: 34880,
                         city: "lavérune")
    )
}
