//
//  AllNewsPresenter.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 18/04/25.
//

import UIKit

protocol AllNewsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapFavorite(at index: Int)
    func numberOfItems() -> Int
    func item(at index: Int) -> NewsItem
    func loadMoreNewsIfNeeded(at index: Int)
}

class AllNewsPresenter: AllNewsPresenterProtocol {
    
    private weak var view: AllNewsViewProtocol?
    private var news: [NewsItem] = []
    private var currentPage = 1
    private var isLoading = false

    init(view: AllNewsViewProtocol) {
        self.view = view
    }

    func viewDidLoad() {
        fetchNews()
    }

    private func fetchNews() {
        guard !isLoading else { return }
        isLoading = true

        NewsNetworkService.shared.fetchNews(page: currentPage) { [weak self] items in
            guard let self = self else { return }

            if self.currentPage == 1 {
                self.news = items
            } else {
                self.news.append(contentsOf: items)
            }

            self.isLoading = false
            self.view?.displayNews(self.news)
        }
    }

    func numberOfItems() -> Int {
        return news.count
    }

    func item(at index: Int) -> NewsItem {
        return news[index]
    }

    func didTapFavorite(at index: Int) {
        let item = news[index]
        FavoritesManager.shared.toggleFavorite(for: item)
        view?.updateFavorite(at: index)
    }

    func loadMoreNewsIfNeeded(at index: Int) {
        if index == news.count - 1 && !isLoading {
            currentPage += 1
            fetchNews()
        }
    }
}
