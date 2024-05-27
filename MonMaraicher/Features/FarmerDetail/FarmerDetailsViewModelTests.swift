//
//  FarmerDetailsViewModelTests.swift
//  MonMaraicherTests
//
//  Created by Yves Charpentier on 03/05/2024.
//

import XCTest
import CoreLocation
@testable import MonMaraicher

final class FarmerDetailsViewModelTests: XCTestCase {

    private var viewModel: FarmerDetailsViewModel?

    func testFarmerNameShouldReturnCorrectNameOfFarmer() {
        // Given
        let markerMock = Farmer.makeMock(name: "l'abeille du pic")

        // When
        self.viewModel = FarmerDetailsViewModel(marker: markerMock)

        // Then
        XCTAssertNotNil(viewModel?.title)
    }

    func testFarmerHaveNoBusinessPhoneShouldReturnPersonalPhone() {
        // Given
        let markerMock = Farmer.makeMock(personalPhone: "0606060606", businessPhone: nil)

        // When
        self.viewModel = FarmerDetailsViewModel(marker: markerMock)

        // Then
        XCTAssertNotNil(viewModel?.phoneNumber)
    }
}

extension Farmer {

    static func makeMock(id: Int = 0, name: String = "", personalPhone: String? = "", businessPhone: String? = "", email: String? = "", websites: [Websites] = [], place: String = "", zipCode: String = "", city: String = "", latitude: Double = 0, longitude: Double = 0, products: [Products] = []) -> MapViewModel.Marker {
        let address = Address(id: id, place: place, zipCode: zipCode, city: city, latitude: latitude, longitude: longitude, farmerAddressesTypes: [])
        let farmer = Farmer(id: id, businessName: name, personalPhone: personalPhone, email: email, businessPhone: businessPhone, websites: websites, addresses: [address], products: products)
        return MapViewModel.Marker(farmer: farmer, address: address)
    }
}
