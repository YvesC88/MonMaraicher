//
//  FarmerDetailsViewModelTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 03/05/2024.
//

import XCTest
@testable import MonMaraicher

final class FarmerDetailsViewModelTests: XCTestCase {

    func testFarmerAddressShouldReturnFormattedAddress() {
        // Given
        let farmerMock = Farmer.makeMock(place: "20 rue de la paix", zipCode: "75000", city: "paris")
        let farmerDetail = FarmerDetailsViewModel(marker: farmerMock)

        // When
        let expectedFormattedAddress = "20 Rue De La Paix\n75000 Paris"

        // Then
        XCTAssertEqual(farmerDetail.address, expectedFormattedAddress)
    }
}

extension Farmer {

    static func makeMock(id: Int = 0, name: String = "", phoneNumber: String? = "", email: String? = "", websites: [Websites] = [], place: String = "", zipCode: String = "", city: String = "", latitude: Double = 0, longitude: Double = 0, products: [Products] = []) -> MapViewModel.Marker {
        let address = Address(id: id, place: place, zipCode: zipCode, city: city, latitude: latitude, longitude: longitude, farmerAddressesTypes: [])
        let farmer = Farmer(id: id, businessName: name, personalPhone: phoneNumber, email: email, businessPhone: phoneNumber, websites: websites, addresses: [address], products: products)
        return MapViewModel.Marker(farmer: farmer, address: address)
    }
}
