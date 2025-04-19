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
    
    func saveFavorite(newsItem: NewsItem) {
        var favorites = getFavorites()
        favorites.append(newsItem)
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    func removeFavorite(newsItem: NewsItem) {
        var favorites = getFavorites()
        favorites.removeAll { $0.title == newsItem.title }
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
    
    func isFavorite(newsItem: NewsItem) -> Bool {
        let favorites = getFavorites()
        return favorites.contains { $0.title == newsItem.title }
    }
    
    func getFavorites() -> [NewsItem] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let favorites = try? JSONDecoder().decode([NewsItem].self, from: data) else {
            return []
        }
        return favorites
    }
}
