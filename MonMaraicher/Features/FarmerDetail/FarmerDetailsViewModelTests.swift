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

    func testFarmerNameShouldReturnCorrectNameOfFarmer() {
        // Given
        let markerMock = Farmer.makeMock(name: "l'abeille du pic")

        // When
        let viewModel = FarmerDetailsViewModel(marker: markerMock)
        let expectedBusinessName = "L'abeille Du Pic"

        // Then
        XCTAssertEqual(viewModel.title, expectedBusinessName)
    }

    func testFarmerHaveNoBusinessPhoneNumberAndShouldReturnPersonalPhoneNumber() {
        // Given
        let markerMock = Farmer.makeMock(personalPhone: "0606060606", businessPhone: nil)

        // When
        let viewModel = FarmerDetailsViewModel(marker: markerMock)
        let expectedPersonalPhone = "0606060606"

        // Then
        XCTAssertEqual(viewModel.phoneNumber, expectedPersonalPhone)
    }

    func testFarmerHaveNoPersonalPhoneNumberAndShouldReturnBusinessPhoneNumber() {
        // Given
        let markerMock = Farmer.makeMock(personalPhone: nil, businessPhone: "0606060606")

        // When
        let viewModel = FarmerDetailsViewModel(marker: markerMock)
        let expectedBusinessPhone = "0606060606"

        // Then
        XCTAssertEqual(viewModel.phoneNumber, expectedBusinessPhone)
    }

    func testFarmerHaveNoPersonalPhoneAndNoBusinessPhoneNumberAndSouldReturnNoPhoneNumber() {
        // Given
        let markerMock = Farmer.makeMock(personalPhone: nil, businessPhone: nil)

        // When
        let viewModel = FarmerDetailsViewModel(marker: markerMock)

        // Then
        XCTAssertNil(viewModel.phoneNumber)
    }

    func testFarmerHaveEmailAddressAndShouldReturnCorrectEmailAddress() {
        // Given
        let markerMock = Farmer.makeMock(email: "test@test.fr")

        // When
        let viewModel = FarmerDetailsViewModel(marker: markerMock)
        let expectedEmail = "test@test.fr"

        // Then
        XCTAssertEqual(viewModel.email, expectedEmail)
    }

    func testFarmerHaveNoEmailAddressAndShouldReturnNoEmailAddress() {
        // Given
        let markerMock = Farmer.makeMock(email: nil)

        // When
        let viewModel = FarmerDetailsViewModel(marker: markerMock)

        // Then
        XCTAssertNil(viewModel.email)
    }

    func testGetProductsImagesNamesWithMultipleProducts() {
        // Given
        let products = [Products(id: 1, name: "laitue"), Products(id: 2, name: "raisin"), Products(id: 3, name: "pomme")]
        let markerMock = Farmer.makeMock(products: products)
        let viewModel = FarmerDetailsViewModel(marker: markerMock)

        // When
        let imageNames = viewModel.getProductsImagesNames(products: products)
        let expectedImages = ["pomme", "laitue", "raisin"].sorted()

        // Then
        XCTAssertEqual(imageNames, expectedImages)
    }

    func testNotGetProductsImagesNamesWithMultipleProducts() {
        // Given
        let products = [Products(id: 1, name: "test"), Products(id: 2, name: "test2")]
        let markerMock = Farmer.makeMock(products: products)
        let viewModel = FarmerDetailsViewModel(marker: markerMock)

        // When
        let imageNames = viewModel.getProductsImagesNames(products: products)

        // Then
        XCTAssertEqual(imageNames, [])
    }

    func testFormatWebSiteAndShouldReturnCorrectWebsite() {
        // Given
        let websiteType = WebsiteType(id: 1, name: "Facebook")
        let website = Websites(id: 1, url: "https://www.facebook.com", active: true, operatorId: 1, websiteType: websiteType)
        let markerMock = Farmer.makeMock(websites: [website])
        let viewModel = FarmerDetailsViewModel(marker: markerMock)

        // When
        let formatWebsiteString = viewModel.formatWebsite(website)
        let expectedFormatWebsite = "[Facebook](https://www.facebook.com)"

        // Then
        XCTAssertEqual(formatWebsiteString, expectedFormatWebsite)
    }
}

extension Farmer {

    static func makeMock(id: Int = 0, name: String = "", personalPhone: String? = "", businessPhone: String? = "", email: String? = "", websites: [Websites] = [], distance: String = "", place: String = "", zipCode: String = "", city: String = "", latitude: Double = 0, longitude: Double = 0, products: [Products] = []) -> MapViewModel.Marker {
        let address = Address(id: id, place: place, zipCode: zipCode, city: city, latitude: latitude, longitude: longitude, farmerAddressesTypes: [])
        let farmer = Farmer(id: id, businessName: name, personalPhone: personalPhone, email: email, businessPhone: businessPhone, websites: websites, addresses: [address], products: products)
        return MapViewModel.Marker(farmer: farmer, address: address)
    }
}
