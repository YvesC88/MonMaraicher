//
//  FarmerServiceTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 18/03/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmerServiceTests: XCTestCase {

    let farmerService = FarmerService()

    func testloadFarmersShouldReturnNoFarmers() {
        // Then
        XCTAssertThrowsError(try farmerService.loadFarmers(forName: "farmers"))
    }

    func testloadFarmersShouldReturnFarmers() {
        // Then
        XCTAssertNoThrow(try farmerService.loadFarmers(forName: "Farmers"))
    }
}
