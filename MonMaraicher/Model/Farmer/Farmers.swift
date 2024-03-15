//
//  FarmersPlaces.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 13/03/2024.
//

import Foundation

struct Farmer: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let location: Location
    let images: FarmerImages
}

struct FarmerImages: Decodable, Hashable {
    let farmer1: String
    let farmer2: String
    let farmer3: String
    let farmer4: String
    let farmer5: String
    let farmer6: String
}
