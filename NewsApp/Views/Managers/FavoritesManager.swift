//
//  FavoritesManager.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 17/04/25.
//
import UIKit

class FavoritesManager {
    
    static let shared = FavoritesManager()
    private let favoritesKey = "favorites"
    
    private init() {}
    
    func saveFavorite(newsItem: NewsItem) {
        var favorites = getFavorites()
        if !favorites.contains(where: { $0.link == newsItem.link }) {
            favorites.append(newsItem)
            saveFavorites(favorites)
        }
    }
    
    func removeFavorite(newsItem: NewsItem) {
        var favorites = getFavorites()
        favorites.removeAll { $0.link == newsItem.link }
        saveFavorites(favorites)
    }
    
    func isFavorite(newsItem: NewsItem) -> Bool {
        return getFavorites().contains { $0.link == newsItem.link }
    }
    
    func getFavorites() -> [NewsItem] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([NewsItem].self, from: data) else {
            return []
        }
        return favorites
    }
    
    private func saveFavorites(_ favorites: [NewsItem]) {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
}
