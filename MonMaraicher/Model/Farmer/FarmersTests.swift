//
//  FarmersTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 03/05/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmersTests: XCTestCase {

    func testTitleShouldReturnFarmerPlaceNameCapitalized() {

        // Given
        let farmer = Farmer.makeMock(name: "L'Abeille du Pic")

        // When
        let expectedTitle = "L'abeille Du Pic"

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

extension Farmer {

    static func makeMock(id: Int = 0, name: String = "", phone: String? = "", email: String? = "", systemImageName: String = "laurel.leading", websites: [Websites] = [], addresses: [Address] = [], products: [Products] = []) -> Farmer {
        return Farmer(id: id, businessName: name, personalPhone: phone, email: email, businessPhone: phone, websites: websites, addresses: addresses, products: products)
    }
}
