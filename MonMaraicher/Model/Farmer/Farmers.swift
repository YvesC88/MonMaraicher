//
//  Produceurs.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 10/04/2024.
//

import Foundation

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
    let adressesOperateurs: [AdressesOperateurs]
    let productions: [Productions]
//    let activites: [Activities]
//    let certificats: [Certificats]
//    let mixite: String
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

struct AdressesOperateurs: Decodable, Identifiable, Hashable {
    let id: Int
    let lieu: String
    let codePostal: String
    let ville: String
    let lat, long: Double
    let typeAdresseOperateurs: [String]
}

struct Productions: Decodable, Identifiable, Hashable {
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
