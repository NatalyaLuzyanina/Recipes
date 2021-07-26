//
//  FoodCollectionViewCell.swift
//  myRecipes
//
//  Created by Nataly on 15.06.2021.
//

import UIKit

class FoodCategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var foodCategoryLabel: UILabel!
    @IBOutlet weak var foodImage: UIImageView!
    
    func setCell(with category: Category) {
        foodImage.image = UIImage(named: category.rawValue)
        foodCategoryLabel.text = category.rawValue
    }
}
