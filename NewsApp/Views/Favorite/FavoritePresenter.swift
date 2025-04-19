//
//  FavoritesPresenter.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 19/04/25.
//

import UIKit

protocol FavoritePresenterProtocol: AnyObject {
    var numberOfItems: Int { get }
    func item(at index: Int) -> NewsItem
    func viewWillAppear()
    func didSelectFavorite(at index: Int)
    func removeFavorite(at index: Int)
}

class FavoritePresenter: FavoritePresenterProtocol {
    
    private weak var view: FavoriteViewProtocol?
    private var favorites: [NewsItem] = []

    init(view: FavoriteViewProtocol) {
        self.view = view
    }
    
    var numberOfItems: Int {
        return favorites.count
    }
    
    func item(at index: Int) -> NewsItem {
        return favorites[index]
    }
    
    func viewWillAppear() {
        favorites = FavoritesManager.shared.getFavorites()
        view?.displayFavorites(favorites)
    }
    
    func didSelectFavorite(at index: Int) {
        let item = favorites[index]
    }
    
    func removeFavorite(at index: Int) {
        let item = favorites[index]
        FavoritesManager.shared.removeFavorite(newsItem: item)
        favorites = FavoritesManager.shared.getFavorites()
        view?.displayFavorites(favorites)
    }
}
