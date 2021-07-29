//
//  DetailRecipeViewController.swift
//  myRecipes
//
//  Created by Nataly on 22.06.2021.
//

import UIKit
import RealmSwift

enum Mark: String {
    case favorite = "suit.heart.fill"
    case notFavorite = "heart"
}

class DetailRecipeViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingridientsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - Public Properties
    var recipe: Recipe!
   
    // MARK: - Life cycle methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        if UserDefaults.standard.object(forKey: recipe.title) != nil {
            setFavoriteButton(Mark.favorite.rawValue)
        }
        getRecipes()
    }
    
    // MARK: - IB Actions
    @IBAction func backButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func favoriteButtonPressed(_ sender: UIButton) {
        
        if UserDefaults.standard.object(forKey: recipe.title) == nil {
            UserDefaults.standard.set(recipe.id, forKey: recipe.title)
            StorageManager.shared.save(recipe: [recipe])
            setFavoriteButton(Mark.favorite.rawValue)
        } else {
            guard let favoriteRecipe = StorageManager.shared.realm.objects(Recipe.self)
                    .filter("id = \(self.recipe.id)")
                    .first
            else { return }
            
            UserDefaults.standard.removeObject(forKey: recipe.title)
            StorageManager.shared.delete(recipe: favoriteRecipe)
            setFavoriteButton(Mark.notFavorite.rawValue)
        }
    }
    
    // MARK: - Private Methods
    
    private func setFavoriteButton(_ mark: String) {
        favoriteButton.setImage(UIImage(systemName: mark), for: .normal)
    }
    
    private func getRecipes() {
        
        NetworkManager.shared.fetchRecipe(recipe: recipe) { recipe in
            DispatchQueue.main.async {
                self.recipe = recipe
                self.activityIndicator.stopAnimating()
                self.setContent()
            }
        }
    }
    
    private func setContent() {
        
        titleLabel.text = recipe.title
        recipeImageView.image = ImageManager.shared.getImage(from: recipe.image)
        
        var steps: [String] = []
        var ingredients: [String] = []
        
        guard let analyzedInstructions = recipe.analyzedInstructions else { return }
        for analyzedInstruction in analyzedInstructions {
            
            for step in analyzedInstruction.steps! {
                for ingridient in step.ingredients! {
                    ingredients.append(ingridient.name ?? "")
                }
                steps.append(step.step ?? "")
            }
        }
        
        let ingredientsDescription = ingredients
            .map({ "\($0)" })
            .joined(separator: ", ")
        ingridientsLabel.text = ingredientsDescription
        ingridientsLabel.layer.cornerRadius = 7
        ingridientsLabel.layer.masksToBounds = true
        
        let stepsDescription = steps
            .map(({ "🧑🏽‍🍳 \($0)" }))
            .joined(separator: "\n")
        stepsLabel.text = stepsDescription
        stepsLabel.layer.cornerRadius = 10
        stepsLabel.layer.masksToBounds = true
    }
}

