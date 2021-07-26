//
//  NetworkManager.swift
//  myRecipes
//
//  Created by Nataly on 16.07.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func fetchRecipes(dishType: Category, completion: @escaping (([Recipe]) -> Void)) {
        
        guard let url = URL(string: APIManager.shared.createURL(with: dishType)) else { print("no url"); return }
        
        URLSession.shared.dataTask(with: url) { (data, _, errror) in
            guard let data = data else {
                print(errror?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let recipes = try JSONDecoder().decode(Welcome.self, from: data)
                completion(recipes.results)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchRecipe(recipe: Recipe, completion: @escaping ((Recipe?) -> Void)) {
        
        guard let url = URL(string: APIManager.shared.createURL(forSearch: recipe)) else { return }
       
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "No error description")
                return
            }
            
            do {
                let recipe = try JSONDecoder().decode([Recipe].self, from: data)
                completion(recipe.first)
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
     
    
}
