//
//  ProductCategory.swift
//  MonMaraicher
//
//  Created by Yves Charpentier on 14/06/2024.
//

import Foundation

struct ProductCategory {
    let name: String
    let products: [ProductsImages]
    let image: IconName
}

let allProductsCategories: [ProductCategory] = [
    .init(name: "Légumes", products: [.artichoke, .chicory, .cabbage, .cauliflower, .spinach, .lettuce, .celery, .corn, .eggplant, .zucchini, .pepper, .potatoes, .carrot, .beet, .vegetable], image: .iconLegume),
    .init(name: "Fruits", products: [.cherry, .strawberry, .raspberry, .grapefruit, .apricot, .grape, .apple, .peach, .pear, .watermelon, .fig, .kiwi, .tomato, .jam, .fruit], image: .iconFruit),
    .init(name: "Miel", products: [.beeswax, .honey, .hive], image: .iconMiel),
    .init(name: "Céréales", products: [.wheat], image: .iconCereal),
    .init(name: "Épices", products: [.thyme, .hemp], image: .iconEpice),
    .init(name: "Boulangeries", products: [.bread, .rusk, .biscuit, .sandwich, .pastrie, .gingerbread], image: .iconPain),
    .init(name: "Huiles", products: [.oliveOil, .rawOliveOil, .preserves], image: .iconHuile),
    .init(name: "Viandes", products: [.pig, .meat], image: .iconViande)
]

enum IconName: String {
    case iconLegume
    case iconFruit
    case iconMiel
    case iconCereal
    case iconEpice
    case iconPain
    case iconHuile
    case iconViande
}

enum ProductsImages: String, CaseIterable {
    case artichoke = "artichaut"
    case cherry = "cerise"
    case chicory = "chicorée"
    case cabbage = "choux"
    case cauliflower = "choux-fleurs"
    case beeswax = "cire d'abeille"
    case spinach = "épinard"
    case strawberry = "fraise"
    case lettuce = "laitue"
    case honey = "miel"
    case hive = "ruche"
    case raspberry = "framboise"
    case grapefruit = "pamplemousse"
    case thyme = "thym"
    case olive = "olive"
    case apricot = "abricot"
    case grape = "raisin"
    case tomato = "tomate"
    case vegetable = "légume"
    case apple = "pomme"
    case wheat = "blé"
    case peach = "pêche"
    case pear = "poire"
    case celery = "céleris branche"
    case corn = "maïs"
    case watermelon = "pastèque"
    case eggplant = "aubergine"
    case zucchini = "courgette"
    case pepper = "poivron"
    case oliveOil = "huile d'olive"
    case rawOliveOil = "huile d'olive, brute"
    case potatoes = "pommes de terre"
    case preserves = "conserves"
    case carrot = "carotte"
    case jam = "confiture"
    case hemp = "chanvre"
    case aromaticPlants = "épices"
    case pig = "porc"
    case meat = "viande"
    case fig = "figue"
    case kiwi = "kiwi"
    case beet = "betterave"
    case bread = "pain"
    case fruit = "fruit"
    case rusk = "biscotte"
    case sandwich = "sandwich"
    case pastrie = "viennoiserie"
    case biscuit = "biscuit"
    case gingerbread = "pains d'épices"
}
