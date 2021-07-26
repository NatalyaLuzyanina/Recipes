//
//  ImageManager.swift
//  myRecipes
//
//  Created by Nataly on 24.07.2021.
//

import Foundation
import UIKit

class ImageManager {
    
    static let shared = ImageManager()
    private init() {}
    
    func getImage(from stringURL: String) -> UIImage? {
        guard let url = URL(string: stringURL),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data)
        else {
            return UIImage(named: "noImage")
        }
        return image
    }
}
