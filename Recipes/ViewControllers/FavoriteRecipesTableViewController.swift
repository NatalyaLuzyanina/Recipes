//
//  FavoriteRecipesTableViewController.swift
//  myRecipes
//
//  Created by Nataly on 23.06.2021.
//

import UIKit
import RealmSwift

class FavoriteRecipesTableViewController: UITableViewController {

    private var favoriteRecipes: Results<Recipe>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 150
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) 
        favoriteRecipes = StorageManager.shared.realm.objects(Recipe.self)
        tableView.reloadData()
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        guard let recipe = favoriteRecipes?[indexPath.row] else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            UserDefaults.standard.removeObject(forKey: recipe.title)
            StorageManager.shared.delete(recipe: recipe)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteRecipes?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteRecipeCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        let recipe = favoriteRecipes?[indexPath.row]
        
        content.text = recipe?.title
        content.image = ImageManager.shared.getImage(from: recipe?.image ?? "")
        content.imageProperties.cornerRadius = 30
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let recipe = favoriteRecipes?[indexPath.row]
        guard let detailrecipeVC = segue.destination as? DetailRecipeViewController else { return }
        
        detailrecipeVC.recipe = recipe
    }
}



