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

    let farmerServiceMock = FarmerServiceMock()

    func testFarmerNameShouldReturnCorrectNameOfFarmer() async {
        do {
            // Given
            let farmers = try await farmerServiceMock.searchFarmers(location: CLLocation(latitude: 34, longitude: 34))
            let farmer = farmers.items.first!

            // When
            let expectedFarmerName = "L'Abeille du Pic"

            // Then
            XCTAssertEqual(farmer.businessName, expectedFarmerName)
        } catch {

        }
    }

    func testFarmerAddressShouldReturnFormattedAddress() async {
        do {
            // Given
            let farmers = try await farmerServiceMock.searchFarmers(location: CLLocation(latitude: 34, longitude: 34))
            let farmer = farmers.items.first!
            let farmerAddress = farmer.addresses.first!
            let farmerMock = Farmer.makeMock(place: farmerAddress.place, zipCode: farmerAddress.zipCode, city: farmerAddress.city)
            let farmerDetail = FarmerDetailsViewModel(marker: farmerMock)

            // When
            let expectedFormattedAddress = "165 Rue Jean Louis Barrault\n34000 Montpellier"

            // Then
            XCTAssertEqual(farmerDetail.address, expectedFormattedAddress)
        } catch {

        }
    }
}

extension Farmer {

    static func makeMock(id: Int = 0, name: String = "", phoneNumber: String? = "", email: String? = "", websites: [Websites] = [], place: String = "", zipCode: String = "", city: String = "", latitude: Double = 0, longitude: Double = 0, products: [Products] = []) -> MapViewModel.Marker {
        let address = Address(id: id, place: place, zipCode: zipCode, city: city, latitude: latitude, longitude: longitude, farmerAddressesTypes: [])
        let farmer = Farmer(id: id, businessName: name, personalPhone: phoneNumber, email: email, businessPhone: phoneNumber, websites: websites, addresses: [address], products: products)
        return MapViewModel.Marker(farmer: farmer, address: address)
    }
}
