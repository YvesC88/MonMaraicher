//
//  FarmerServiceTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 18/03/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmerServiceTests: XCTestCase {

    func testloadFarmersShouldReturnNoFarmers() {
        // Given
        let farmerService = FarmerService()

        // Then
        XCTAssertThrowsError(try farmerService.loadFarmers(forName: "farmers"))
    }

    func testloadFarmersShouldReturnFarmers() {
        // Given
        let farmerService = FarmerService()

        // Then
        XCTAssertNoThrow(try farmerService.loadFarmers(forName: "Farmers"))
    }
}
