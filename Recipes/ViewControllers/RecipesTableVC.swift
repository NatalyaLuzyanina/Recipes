//
//  RecipesTableViewController.swift
//  myRecipes
//
//  Created by Nataly on 17.06.2021.
//

import UIKit

class RecipesTableViewController: UITableViewController {

    private var recipes: [Recipe]?
    var dishType: Category?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150
        getRecipes()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        
        let recipe = recipes?[indexPath.row]
        
        content.text = recipe?.title
        content.image = ImageManager.shared.getImage(from: recipe?.image ?? "")
        content.imageProperties.cornerRadius = 30
        
        cell.contentConfiguration = content

        return cell
    }

    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let recipe = recipes?[indexPath.row]
        guard let detailrecipeVC = segue.destination as? DetailRecipeViewController else { return }
        
        detailrecipeVC.recipe = recipe
       }

    private func getRecipes() {
        guard let dishType = dishType else { return }
        
        NetworkManager.shared.fetchRecipes(dishType: dishType) { recipes in
            DispatchQueue.main.async {
                self.recipes = recipes
                self.tableView.reloadData()
            }
        }
    }
}


