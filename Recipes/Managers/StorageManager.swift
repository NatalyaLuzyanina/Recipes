//
//  StorageManager.swift
//  myRecipes
//
//  Created by Nataly on 24.06.2021.
//

import RealmSwift

class StorageManager {
    let realm = try! Realm()
    
    static let shared = StorageManager()
    private init() {}
    
    func save(recipe: [Recipe]) {
        write {
            realm.add(recipe)
        }
    }
    
    func delete(recipe: Recipe) {
        write {
            realm.delete(recipe)
        }
    }
    
    private func write(_ completion: () -> Void) {
        do {
            try realm.write { completion() }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

