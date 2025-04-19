//
//  NewsDetailPresenter.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 19/04/25.
//

import UIKit

protocol NewsDetailPresenterProtocol: AnyObject {
    func viewDidLoad()
}

class NewsDetailPresenter: NewsDetailPresenterProtocol {
    
    private weak var view: NewsDetailViewProtocol?
    private let newsItem: NewsItem
    
    init(view: NewsDetailViewProtocol, newsItem: NewsItem) {
        self.view = view
        self.newsItem = newsItem
    }
    
    func viewDidLoad() {
        view?.displayNews(
            title: newsItem.title,
            description: newsItem.description,
            imageUrl: newsItem.image_url,
            pubDate: newsItem.pubDate,
            creator: newsItem.creator
        )
    }
}
