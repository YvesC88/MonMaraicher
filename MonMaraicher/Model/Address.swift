//
//  Address.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 05/03/2024.
//

import Foundation

struct Address: Decodable, Hashable {
    let streetNumber: Int?
    let streetName: String
    let zipCode: Int
    let city: String
}
