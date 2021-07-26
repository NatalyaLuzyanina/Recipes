//
//  DetailRecipeViewController.swift
//  myRecipes
//
//  Created by Nataly on 22.06.2021.
//

import UIKit
import RealmSwift

class DetailRecipeViewController: UIViewController {
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingridientsLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var recipe: Recipe!
    var favoriteRecipes: Results<Recipe>?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .white
        
        favoriteRecipes = StorageManager.shared.realm.objects(Recipe.self).filter("id = \(self.recipe.id)")
        
        if !(favoriteRecipes?.isEmpty ?? true) {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "suit.heart.fill")
        }
        getRecipes()
    }
    
    @IBAction func favoriteAction(_ sender: UIBarButtonItem) {
        
        guard let favoriteRecipes = favoriteRecipes else { return }
        
        if favoriteRecipes.isEmpty {
            StorageManager.shared.save(recipe: [recipe])
            sender.image = UIImage(systemName: "suit.heart.fill")
        } else {
            guard let favoriteRecipe = favoriteRecipes.first else { return }
            
            StorageManager.shared.delete(recipe: favoriteRecipe)
            sender.image = UIImage(systemName: "heart")
        }
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

