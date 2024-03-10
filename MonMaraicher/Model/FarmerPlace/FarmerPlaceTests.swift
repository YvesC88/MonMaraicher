//
//  FarmerPlaceTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 08/03/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmerPlaceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTitleShouldReturnFarmerPlaceNameCapitalized() {

        // Given
        let farmerPlace = FarmerPlace(name: "chez william", location: Location(latitude: 0, longitude: 0, address: Address(streetNumber: 0, streetName: "", zipCode: 0, city: "")), imageNames: [])

        // When
        let expectedTitle = "Chez William"

        // Then
        XCTAssertEqual(farmerPlace.title, expectedTitle)
    }

}
