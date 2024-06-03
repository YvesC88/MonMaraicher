//
//  FarmerServiceTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 01/06/2024.
//

import XCTest
@testable import MonMaraicher
import CoreLocation

final class FarmerServiceTests: XCTestCase {

    let farmerServiceMock = FarmerServiceMock()

    func testFarmerAddressShouldReturnFormattedAddress() async {
        do {
            // Given
            let farmers = try await farmerServiceMock.searchFarmers(around: CLLocation(latitude: 34, longitude: 34))
            let farmer = farmers.items.first!.addresses.first!
            let farmerMock = Farmer.makeMock(place: farmer.place, zipCode: farmer.zipCode, city: farmer.city)
            let farmerDetail = FarmerDetailsViewModel(marker: farmerMock)

            // When
            let expectedFormattedAddress = "165 Rue Jean Louis Barrault\n34000 Montpellier"

            // Then
            XCTAssertEqual(farmerDetail.address, expectedFormattedAddress)
        } catch {

        }
    }

}
