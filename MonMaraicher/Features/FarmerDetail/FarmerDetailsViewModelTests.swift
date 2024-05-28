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
        let expectedBusinessName = "L'abeille Du Pic"

        // Then
        XCTAssertEqual(viewModel?.title, expectedBusinessName)
    }

    func testFarmerHaveNoBusinessPhoneNumberAndShouldReturnPersonalPhoneNumber() {
        // Given
        let markerMock = Farmer.makeMock(personalPhone: "0606060606", businessPhone: nil)

        // When
        self.viewModel = FarmerDetailsViewModel(marker: markerMock)
        let expectedPersonalPhone = "0606060606"

        // Then
        XCTAssertEqual(viewModel?.phoneNumber, expectedPersonalPhone)
    }

    func testFarmerHaveNoPersonalPhoneNumberAndShouldReturnBusinessPhoneNumber() {
        // Given
        let markerMock = Farmer.makeMock(personalPhone: nil, businessPhone: "0606060606")

        // When
        self.viewModel = FarmerDetailsViewModel(marker: markerMock)
        let expectedBusinessPhone = "0606060606"

        // Then
        XCTAssertEqual(viewModel?.phoneNumber, "0606060606")
    }

    func testFarmerHaveNoPersonalPhoneAndNoBusinessPhoneNumberAndSouldReturnNoPhoneNumber() {
        // Given
        let markerMock = Farmer.makeMock(personalPhone: nil, businessPhone: nil)

        // When
        self.viewModel = FarmerDetailsViewModel(marker: markerMock)

        // Then
        XCTAssertNil(viewModel?.phoneNumber)
    }

    func testFarmerHaveEmailAddressAndShouldReturnCorrectEmailAddress() {
        // Given
        let markerMock = Farmer.makeMock(email: "test@test.fr")

        // When
        self.viewModel = FarmerDetailsViewModel(marker: markerMock)
        let expectedEmail = "test@test.fr"

        // Then
        XCTAssertEqual(viewModel?.email, "test@test.fr")
    }

    func testFarmerHaveNoEmailAddressAndShouldReturnNoEmailAddress() {
        // Given
        let markerMock = Farmer.makeMock(email: nil)

        // When
        self.viewModel = FarmerDetailsViewModel(marker: markerMock)

        // Then
        XCTAssertNil(viewModel?.email)
    }
}

extension Farmer {

    static func makeMock(id: Int = 0, name: String = "", personalPhone: String? = "", businessPhone: String? = "", email: String? = "", websites: [Websites] = [], place: String = "", zipCode: String = "", city: String = "", latitude: Double = 0, longitude: Double = 0, products: [Products] = []) -> MapViewModel.Marker {
        let address = Address(id: id, place: place, zipCode: zipCode, city: city, latitude: latitude, longitude: longitude, farmerAddressesTypes: [])
        let farmer = Farmer(id: id, businessName: name, personalPhone: personalPhone, email: email, businessPhone: businessPhone, websites: websites, addresses: [address], products: products)
        return MapViewModel.Marker(farmer: farmer, address: address)
    }
}
