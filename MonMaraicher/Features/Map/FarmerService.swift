//
//  FarmerService.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 15/03/2024.
//

import Foundation

final class FarmerService {

    func loadFarmers() -> [Farmer] {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            if let bundlePath = Bundle.main.path(forResource: "Farmers", ofType: "json"),
               let farmerJson = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let farmers = try decoder.decode([Farmer].self, from: farmerJson)
                return farmers
            }
        } catch {
            // TODO: in another pull request to display error for user /feature/displayError
            print("Error decoding: \(error)")
        }
        return []
    }
}
