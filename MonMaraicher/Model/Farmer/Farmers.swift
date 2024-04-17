//
//  Produceurs.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 10/04/2024.
//

import Foundation

// FIXME: this list of properties are currently changing

struct Farmers: Decodable, Hashable {
    let nbTotal: String
    let items: [Farmer]
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
    let operatorsAddresses: [OperatorsAddresses]
    let products: [Products]
    //    let activites: [Activities]
    //    let certificats: [Certificats]
    //    let mixite: String

    enum CodingKeys: String, CodingKey {
        case id
        case businessName = "raisonSociale"
        case personalPhone = "telephone"
        case businessPhone = "telephoneCommerciale"
        case operatorsAddresses = "adressesOperateurs"
        case products = "productions"
    }
}

struct Categories: Decodable, Identifiable, Hashable {
    let id: Int
    let nom: String
}

struct Activities: Decodable, Identifiable, Hashable {
    let id: Int
    let nom: String
}

struct SiteWebs: Decodable, Identifiable, Hashable {
    let id: Int
    let url: String
    let active: Bool
    let operateurId: Int
    let typeSiteWebId: Int
    let typeSiteWeb: TypeSiteWeb
}

struct TypeSiteWeb: Decodable, Identifiable, Hashable {
    let id: Int
    let nom: String
    let status: Int
}

struct OperatorsAddresses: Decodable, Identifiable, Hashable {
    let id: Int
    let place: String
    let zipCode: String
    let city: String
    let lat, long: Double
    let operatorsAddressesTypes: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case lat
        case long
        case place = "lieu"
        case zipCode = "codePostal"
        case city = "ville"
        case operatorsAddressesTypes = "typeAdresseOperateurs"
    }
}

struct Products: Decodable, Identifiable, Hashable {
    let id: Int
    let nom: String
}

struct Certificats: Decodable, Hashable {
    let organisme: String
    let etatCertification: String
    let dateArret: String
    let dateEngagement: String
    let dateNotification: String
    let url: String
}
