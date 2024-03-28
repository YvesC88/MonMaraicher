//
//  FarmerDetailsViewModelTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 11/03/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmerDetailsViewModelTests: XCTestCase {

    func testFarmerCityShouldReturnCityCapitalized() {
        // Given
        let farmerMock = Farmer.makeMock(city: "paris")
        let farmerDetail = FarmerDetailsViewModel(farmer: farmerMock)

        // When
        let expectedCity = "Paris"

        // Then
        XCTAssertEqual(farmerDetail.city, expectedCity)
    }

    func testFarmerAddressShouldReturnFormattedAddressWithoutStreetNumber() {
        // Given
        let farmerMock = Farmer.makeMock(streetName: "rue de la paix", zipCode: 75000, city: "paris")
        let farmerDetail = FarmerDetailsViewModel(farmer: farmerMock)

        // When
        let expectedFormattedAddress = "Rue De La Paix\n75000 Paris"

        // Then
        XCTAssertEqual(farmerDetail.address, expectedFormattedAddress)
    }

    func testFarmerAddressShouldReturnFormattedAddressWithStreetNumber() {
        // Given
        let farmerMock = Farmer.makeMock(streetNumber: 5, streetName: "rue de la paix", zipCode: 75000, city: "paris")
        let farmerDetail = FarmerDetailsViewModel(farmer: farmerMock)

        // When
        let expectedFormattedAddress = "5 Rue De La Paix\n75000 Paris"

        // Then
        XCTAssertEqual(farmerDetail.address, expectedFormattedAddress)
    }

    func testMarkerSystemImageNameShouldReturnCorrectValue() {
        // Given
        let farmerDetail = FarmerDetailsViewModel(farmer: .makeMock())

        // When
        let expectedMarkerSystemImageName = "laurel.leading"

        // Then
        XCTAssertEqual(farmerDetail.markerSystemImageName, expectedMarkerSystemImageName)
    }
}

extension Farmer {

    static func makeMock(id: Int = 0, name: String = "", streetNumber: Int? = nil, streetName: String = "", zipCode: Int = 0, city: String = "") -> Farmer {
        return Farmer(id: id, name: name, location: .init(latitude: 0, longitude: 0, address: .init(streetNumber: streetNumber, streetName: streetName, zipCode: zipCode, city: city)), images: .init(farmer1: "", farmer2: "", farmer3: "", farmer4: "", farmer5: "", farmer6: ""))
    }
}
