//
//  FoodCategoriesCollectionVC.swift
//  myRecipes
//
//  Created by Nataly on 15.06.2021.
//

import UIKit

class FoodCategoriesCollectionVC: UICollectionViewController {

    private let itemsPerRow: CGFloat = 2
    private let sectionInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    private let categories = Category.allCases
    private var searchController: UISearchController?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        createSearch()
    }
  
    // MARK: - UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "FoodCell",
                for: indexPath
        ) as? FoodCategoryCell else { return UICollectionViewCell() }

        let category = categories[indexPath.item]
        cell.setCell(with: category)
    
        return cell
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard let indexPath = collectionView.indexPathsForSelectedItems else { return }
        let dishType = categories[indexPath.first?.item ?? 0]
        
        guard let recipesVC = segue.destination as? RecipesTableViewController else { return }
        recipesVC.dishType = dishType
        recipesVC.title = dishType.rawValue
    }
    
    // MARK: - Private Methods
    
    private func createSearch() {
        
        let recipeSearchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RecipesTableViewController") as? RecipesTableViewController
        searchController = UISearchController(searchResultsController: recipeSearchVC)
        
        if let searchController = searchController {
            searchController.searchResultsUpdater = recipeSearchVC
            searchController.obscuresBackgroundDuringPresentation = false
            searchController.searchBar.placeholder = "Search"
            navigationItem.searchController = searchController
            definesPresentationContext = true
        }
    }
}

// MARK: - Extensions

extension FoodCategoriesCollectionVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingWidht: CGFloat = 20 * (itemsPerRow + 1)
        let availableWidth =  collectionView.frame.width - paddingWidht
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    // отступы
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    // расстояние по вертикали между объектами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    // расстояние по горизонтали между объектами
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
