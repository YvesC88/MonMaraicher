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
    let raisonSociale: String
    let telephone: String?
    //    let email: String?
    //    let codeNAF: String?
    //    let gerant: String?
    //    let dateMaj: String
    let telephoneCommerciale: String?
    //    let categories: [Categories]
    //    let siteWebs: [SiteWebs]
    let adressesOperateurs: [OperatorsAddresses]
    let productions: [Products]
    //    let activites: [Activities]
    //    let certificats: [Certificats]
    //    let mixite: String


    // TODO: Customizing JSON Key Mapping in Swift with CodingKey Protocol
/*    enum FarmerCodingKeys: String, CodingKey {
        case id
        case raisonSociale = "name"
        case telephone = "personalPhone"
        case telephoneCommerciale = "businessPhone"
        case adressesOperateurs = "operatorAddresses"
        case productions = "products"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: FarmerCodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        raisonSociale = try values.decode(String.self, forKey: .raisonSociale)
        telephone = try values.decodeIfPresent(String.self, forKey: .telephone)
        telephoneCommerciale = try values.decodeIfPresent(String.self, forKey: .telephoneCommerciale)
        adressesOperateurs =  try values.decode([OperatorAddresses].self, forKey: .adressesOperateurs)
        productions = try values.decode([Products].self, forKey: .productions)
    }
 */
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
    let lieu: String
    let codePostal: String
    let ville: String
    let lat, long: Double
    let typeAdresseOperateurs: [String]
}

struct Products: Decodable, Identifiable, Hashable {
    let id: Int
    let code: String
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
