//
//  FarmerService.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 15/03/2024.
//

import Foundation

enum LoadFarmerError: Error {
    case invalidJsonFile
    case errorDecoding
}

final class FarmerService {

    func loadFarmers(handlerError: (Result<[Farmer], LoadFarmerError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            guard let bundlePath = Bundle.main.path(forResource: "Farmers", ofType: "json"),
                  let farmerJson = try String(contentsOfFile: bundlePath).data(using: .utf8) else {
                handlerError(.failure(.invalidJsonFile))
                return
            }
            let farmers = try decoder.decode([Farmer].self, from: farmerJson)
            handlerError(.success(farmers))
        } catch {
            handlerError(.failure(.errorDecoding))
            return
        }
    }
}
