//
//  FarmersTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 03/05/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmersTests: XCTestCase {

    func testTitleShouldReturnFarmerNameCapitalized() {

        // Given
        let farmer = Farmer.makeMock(name: "l'abeille du pic")

        // When
        let expectedTitle = "L'abeille Du Pic"

        // Then
        XCTAssertEqual(farmer.title, expectedTitle)
    }
}
