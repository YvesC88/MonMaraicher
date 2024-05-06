//
//  FarmerService.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 15/03/2024.
//

import Foundation
import CoreLocation

protocol FarmerServiceProtocol {
    func searchFarmers(location: CLLocation) async throws -> Farmers
}

final class FarmerService: FarmerServiceProtocol {

    // TODO: Write unit tests for this method
    func searchFarmers(location: CLLocation) async throws -> Farmers {
        do {
            let endPoint = "https://opendata.agencebio.org/api/gouv/operateurs/?activite=Production&filtrerVenteDetail=1&lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)"
            guard let url = URL(string: endPoint) else {
                throw Error.badUrl
            }
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let response = response as? HTTPURLResponse else { throw
                Error.badResponse
            }
            guard response.statusCode == 200 else {
                throw Error.badStatus
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .deferredToDate
            let farmers = try decoder.decode(Farmers.self, from: data)
            return farmers
        } catch {
            throw Error.failedToDecodeResponse
        }
    }
}

extension FarmerService {

    enum Error: Swift.Error {
        case badUrl
        case badResponse
        case badStatus
        case failedToDecodeResponse
    }
}
