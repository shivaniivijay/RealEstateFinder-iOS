//
//  FavoriteManager.swift
//  RealEstateFinder
//
//  Created by Shivani Vijay on 2025-04-13.
//

import Foundation

class FavoriteManager {
    static let shared = FavoriteManager()
    private var favorites: [Property] = []
    
    private init() {}
    
    func addToFavorites(_ property: Property) {
        if !favorites.contains(where: { $0.zpid == property.zpid }) {
            favorites.append(property)
        }
    }
    
    func getFavorites() -> [Property] {
        return favorites
    }
}
