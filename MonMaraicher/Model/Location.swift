//
//  Location.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 26/02/2024.
//

import Foundation

struct Location: Codable, Hashable {
    let latitude: Double
    let longitude: Double
    let address: Address
}
