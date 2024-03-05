//
//  Address.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 05/03/2024.
//

import Foundation

struct Address: Hashable {
    let streetNumber: Int?
    let streetName: String
    let zip: Int
    let city: String
}
