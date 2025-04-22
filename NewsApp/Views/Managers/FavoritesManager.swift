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

    private func saveFavorites(_ ids: [String]) {
        UserDefaults.standard.set(ids, forKey: favoritesKey)
        UserDefaults.standard.synchronize()
        print("Избранные данные сохранены в UserDefaults: \(ids)")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        }
    }

    func getFavorites() -> [String] {
        return UserDefaults.standard.stringArray(forKey: favoritesKey) ?? []
    }
    
    func filterFavorites(from allItems: [NewsItem]) -> [NewsItem] {
        let favoriteIDs = getFavorites()
        return allItems.filter { favoriteIDs.contains($0.article_id) }
    }

    func isFavorite(_ item: NewsItem) -> Bool {
        return getFavorites().contains(item.article_id)
    }

    func removeFavorite(for item: NewsItem) {
        var favorites = getFavorites()
        favorites.removeAll { $0 == item.article_id }
        saveFavorites(favorites)
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
        print("Избранное обновлено, новость удалена: \(item.article_id)")
    }

    func toggleFavorite(for item: NewsItem) {
        var favorites = getFavorites()

        if let index = favorites.firstIndex(of: item.article_id) {
            favorites.remove(at: index)
            print("Удалено из избранного: \(item.article_id)")
        } else {
            favorites.append(item.article_id)
            print("Добавлено в избранное: \(item.article_id)")
        }

        saveFavorites(favorites)
        NotificationCenter.default.post(name: .favoritesUpdated, object: nil)
    }
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name("favoritesUpdated")
}
