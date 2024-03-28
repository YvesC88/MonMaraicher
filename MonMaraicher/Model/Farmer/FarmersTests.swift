//
//  FarmerPlaceTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 08/03/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmersTests: XCTestCase {

    func testTitleShouldReturnFarmerPlaceNameCapitalized() {

        // Given
        let farmer = Farmer.makeMock(name: "chez william")

        // When
        let expectedTitle = "Chez William"

        // Then
        XCTAssertEqual(farmer.title, expectedTitle)
    }

    func testSystemImageNameShouldReturnCorrectlyValue() {
        // Given
        let farmer = Farmer.makeMock()

        // When
        let expectedSystemImageName = "laurel.leading"

        // Then
        XCTAssertEqual(farmer.systemImageName, expectedSystemImageName)
    }

}
