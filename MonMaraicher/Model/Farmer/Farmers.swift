//
//  Produceurs.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 10/04/2024.
//

import Foundation
import CoreLocation
import SwiftUI

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
    let email: String?
    //    let gerant: String?
    //    let dateMaj: String
    let businessPhone: String?
    //    let categories: [Categories]
    let websites: [Websites]
    let addresses: [Address]
    let products: [Products]
    //    let activites: [Activities]
    //    let certificats: [Certificats]
    //    let mixite: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case businessName = "raisonSociale"
        case personalPhone = "telephone"
        case businessPhone = "telephoneCommerciale"
        case addresses = "adressesOperateurs"
        case products = "productions"
        case websites = "siteWebs"
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
    let operatorId: Int
    let websiteType: WebsiteType

    enum CodingKeys: String, CodingKey {
        case id
        case url
        case active
        case operatorId = "operateurId"
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

struct Address: Decodable, Identifiable, Hashable {
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
}

enum ImagesProducts {
    static let productsImagesNames = [
        "artichauts",
        "cerises",
        "chicorées",
        "choux",
        "cire d'abeille",
        "épinards",
        "fraises",
        "laitues",
        "miel",
        "ruches",
        "framboises",
        "pomelos et pamplemousses",
        "thyms",
        "olives",
        "abricots",
        "raisin de cuve",
        "raisin de table",
        "tomates",
        "légumes frais plein champ",
        "légumes frais sous abris",
        "pommes de table",
        "pommes à cidre",
        "blé tendre",
        "choux-fleurs et brocolis"
    ]
}
