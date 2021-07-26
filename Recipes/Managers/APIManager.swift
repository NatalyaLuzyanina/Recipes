//
//  ApiManager.swift
//  myRecipes
//
//  Created by Nataly on 16.07.2021.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private init() {}
    
    private let apiKey = "7bd8cced65934b6499ea5beebd2e8b0a"

    func createURL(with dishType: Category) -> String {
        let dishType = convertSpace(in: dishType)
        return "https://api.spoonacular.com/recipes/complexSearch?type=\(dishType)&apiKey=\(apiKey)"
    }
    
    func createURL(forSearch recipe: Recipe) -> String {
        return "https://api.spoonacular.com/recipes/informationBulk?ids=\(recipe.id)&apiKey=\(apiKey)"
    }
    
    func convertSpace(in dishType: Category) -> String {
        let dishType = dishType.rawValue
        
        var replaced = ""
        
        if dishType.contains(" ") {
            replaced = String(dishType.map {
                $0 == " " ? "+" : $0
            })
        } else {
            return dishType
        }
        return replaced
    }
}
