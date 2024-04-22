//
//  Produceurs.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 10/04/2024.
//

import Foundation
import CoreLocation

// FIXME: this list of properties are currently changing

struct Farmers: Decodable, Hashable {
    let totalNumber: Int
    let items: [Farmer]

    enum CodingKeys: String, CodingKey {
        case totalNumber = "nbTotal"
        case items
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let totalNumberString = try container.decode(String.self, forKey: .totalNumber)
        self.totalNumber = Int(totalNumberString) ?? 0
        self.items = try container.decode([Farmer].self, forKey: .items)
    }
}

struct Farmer: Decodable, Identifiable, Hashable {
    let id: Int
    let businessName: String
    let personalPhone: String?
    //    let email: String?
    //    let gerant: String?
    //    let dateMaj: String
    let businessPhone: String?
    //    let categories: [Categories]
    //    let siteWebs: [SiteWebs]
    let addresses: [Addresses]
    let products: [Products]
    //    let activites: [Activities]
    //    let certificats: [Certificats]
    //    let mixite: String

    enum CodingKeys: String, CodingKey {
        case id
        case businessName = "raisonSociale"
        case personalPhone = "telephone"
        case businessPhone = "telephoneCommerciale"
        case addresses = "adressesOperateurs"
        case products = "productions"
    }
}

struct Categories: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "nom"
    }
}

struct Activities: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "nom"
    }
}

struct Websites: Decodable, Identifiable, Hashable {
    let id: Int
    let url: String
    let active: Bool
    let idOperator: Int
    let idWebsiteType: Int
    let websiteType: WebsiteType

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case active
        case idOperator = "operateurId"
        case idWebsiteType = "typeSiteWebId"
        case websiteType = "typeSiteWeb"
    }
}

struct WebsiteType: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "nom"
    }
}

struct Addresses: Decodable, Identifiable, Hashable {
    let id: Int
    let place: String
    let zipCode: String
    let city: String
    let latitude, longitude: Double
    let farmerAddressesTypes: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case latitude = "lat"
        case longitude = "long"
        case place = "lieu"
        case zipCode = "codePostal"
        case city = "ville"
        case farmerAddressesTypes = "typeAdresseOperateurs"
    }
}

struct Products: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name = "nom"
    }
}

struct Certificats: Decodable, Hashable {
    let organization: String
    let certificationStatus: String
    let commitmentDate: Date
    let url: String

    enum CodingKeys: String, CodingKey {
        case organization = "organisme"
        case certificationStatus = "etatCertification"
        case commitmentDate = "dateEngagement"
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.organization = try container.decode(String.self, forKey: .organization)
        self.certificationStatus = try container.decode(String.self, forKey: .certificationStatus)
        self.commitmentDate = try container.decode(Date.self, forKey: .commitmentDate)
        self.url = try container.decode(String.self, forKey: .url)
    }
}
