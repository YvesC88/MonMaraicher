//
//  FarmerDetailsTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 11/03/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmerDetailsViewModelTests: XCTestCase {

    func testFarmerCityShouldReturnCityCapitalized() {
        // Given
        let farmer = Farmer(id: 0, name: "", location: .init(latitude: 0, longitude: 0, address: .init(streetNumber: nil, streetName: "", zipCode: 0, city: "montpellier")), images: .init(farmer1: "", farmer2: "", farmer3: "", farmer4: "", farmer5: "", farmer6: ""))
        let farmerDetail = FarmerDetailsViewModel(farmer: farmer)

        // When
        let expectedCity = "Montpellier"

        // Then
        XCTAssertEqual(farmerDetail.city, expectedCity)
    }

    func testFarmerAddressShouldReturnFormattedAddressWithoutStreetNumber() {
        // Given
        let farmer = Farmer(id: 0, name: "", location: .init(latitude: 0, longitude: 0, address: .init(streetNumber: nil, streetName: "rue de la paix", zipCode: 75000, city: "paris")), images: .init(farmer1: "", farmer2: "", farmer3: "", farmer4: "", farmer5: "", farmer6: ""))
        let farmerDetail = FarmerDetailsViewModel(farmer: farmer)

        // When
        let expectedFormattedAddress = "Rue De La Paix\n75000 Paris"

        // Then
        XCTAssertEqual(farmerDetail.address, expectedFormattedAddress)
    }
}
