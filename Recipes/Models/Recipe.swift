//
//  Recipe.swift
//  myRecipes
//
//  Created by Nataly on 13.06.2021.
//

import RealmSwift

struct Welcome: Decodable {
    let results: [Recipe]
}

class Recipe: Object, Decodable {
    @objc dynamic var id: Int
    @objc dynamic var title: String
    @objc dynamic var image: String
    let dishTypes: [String]?
    let instructions: String?
    let analyzedInstructions: [AnalyzedInstruction]?
    let extendedIngredients: [Ingredient]?
}

struct AnalyzedInstruction: Decodable {
    let steps: [Step]?
}

struct Step: Decodable {
    let number: Int?
    let step: String?
    let ingredients: [Ingredient]?
}

struct Ingredient: Decodable {
    let original: String?
    let image: String?
}


enum Category: String, CaseIterable {
    case firstDish = "Main course"
    case secondDish = "Side dish"
    case dessert = "Dessert"
    case drink = "Drink"
    case salad = "Salad"
    case breakfast = "Breakfast"
    case appetizer = "Appetizer"
}
