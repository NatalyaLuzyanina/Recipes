//
//  RecipesTableViewController.swift
//  myRecipes
//
//  Created by Nataly on 17.06.2021.
//

import UIKit

class RecipesTableViewController: UITableViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = recipes?[indexPath.row]
        let viewControllers = navigationController?.viewControllers
        
        viewControllers?.forEach({
            if let detailVC = $0 as? DetailRecipeViewController {
                detailVC.recipe = recipe
                
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        })
    }
    
    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let recipe = recipes?[indexPath.row]
        
        guard let detailrecipeVC = segue.destination as? DetailRecipeViewController else { return }
        detailrecipeVC.recipe = recipe
    }
    
    //MARK: - Private Methods
    
    private func getRecipes() {
        guard let dishType = dishType else { return }
        
        NetworkManager.shared.fetchRecipes(dishType: dishType) { recipes in
            DispatchQueue.main.async {
                self.recipes = recipes
                self.tableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

//MARK: - Extensions

extension RecipesTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        NetworkManager.shared.fetchRecipes(query: query) { (recipes) in
            DispatchQueue.main.async {
                self.recipes = recipes
                self.tableView.reloadData()
            }
        }
    }
    
    
    
}
