//
//  FarmersPlaces.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 13/03/2024.
//

import Foundation

struct Farmers: Decodable {
    let farmers: [Farmer]
}

struct Farmer: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let location: Location
    let images: FarmerImages
}

struct FarmerImages: Decodable, Hashable {
    let farmer1, farmer2, farmer3, farmer4, farmer5, farmer6: String
}
