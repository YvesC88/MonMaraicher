//
//  FarmerPlaceTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 08/03/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmerPlaceTests: XCTestCase {

    func testTitleShouldReturnFarmerPlaceNameCapitalized() {

        // Given
        let farmerPlace = Farmer(id: 0, name: "chez william", location: .init(latitude: 0, longitude: 0, address: .init(streetNumber: nil, streetName: "", zipCode: 0, city: "")), images: .init(farmer1: "", farmer2: "", farmer3: "", farmer4: "", farmer5: "", farmer6: ""))

        // When
        let expectedTitle = "Chez William"

        // Then
        XCTAssertEqual(farmerPlace.title, expectedTitle)
    }

}
