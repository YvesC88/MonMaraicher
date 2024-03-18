//
//  FarmerService.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 15/03/2024.
//

import Foundation

final class FarmerService {

    func loadFarmers() throws -> [Farmer] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Farmers", ofType: "json"),
                  let farmerJson = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
                throw Error.invalidJsonFile
            }
            let farmers = try decoder.decode([Farmer].self, from: farmerJson)
            return farmers
        } catch {
            throw Error.decodingError
        }
    }
}

extension FarmerService {

    enum Error: Swift.Error {
        case invalidJsonFile
        case decodingError
    }
}
