//
//  FarmerServiceMock.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 07/05/2024.
//

import Foundation
import CoreLocation

class FarmerServiceMock: FarmerServiceProtocol {
    func searchFarmers(location: CLLocation) async throws -> Farmers {
        let bundlePath = Bundle.main.path(forResource: "Farmers", ofType: "json")!
        let data = try Data(contentsOf: URL(filePath: bundlePath))
        let farmers = try JSONDecoder().decode(Farmers.self, from: data)
        return farmers
    }
}
