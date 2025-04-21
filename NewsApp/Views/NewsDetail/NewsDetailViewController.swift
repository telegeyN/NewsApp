//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 17/04/25.
//

import UIKit

protocol NewsDetailViewProtocol: AnyObject {
    func displayNews(title: String?, description: String?, imageUrl: String?, pubDate: String?, creator: [String]?)
    func setNewsItem(_ item: NewsItem)
}

class NewsDetailViewController: UIViewController, NewsDetailViewProtocol {
    
    var presenter: NewsDetailPresenterProtocol?
    private var currentNewsItem: NewsItem?

    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 12
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pubDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let creatorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        button.tintColor = UIColor(hex: "#D6A4A4")
        return button
    }()
    
    private let sourceLinkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Читать в источнике", for: .normal)
        button.setTitleColor(UIColor(hex: "#D6A4A4"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: "#D6A4A4").cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var sourceURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
        navigationItem.rightBarButtonItem = favoriteButton
    }

    private func setupUI() {
        view.backgroundColor = UIColor(hex: "#FAF8F6")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "← Назад",
            style: .plain,
            target: self,
            action: #selector(backTapped)
        )
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([
            .foregroundColor: UIColor(hex: "#5E5E5E"),
            .font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ], for: .normal)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(pubDateLabel)
        contentView.addSubview(creatorLabel)
        contentView.addSubview(sourceLinkButton)
        sourceLinkButton.addTarget(self, action: #selector(sourceLinkTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.6),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            pubDateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            pubDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            pubDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            creatorLabel.topAnchor.constraint(equalTo: pubDateLabel.bottomAnchor, constant: 8),
            creatorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            creatorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            sourceLinkButton.topAnchor.constraint(equalTo: creatorLabel.bottomAnchor, constant: 16),
            sourceLinkButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sourceLinkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            sourceLinkButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func favoriteTapped() {
        guard let currentNewsItem = currentNewsItem else { return }

        if FavoritesManager.shared.isFavorite(newsItem: currentNewsItem) {
            FavoritesManager.shared.removeFavorite(newsItem: currentNewsItem)
            favoriteButton.image = UIImage(systemName: "heart")
        } else {
            FavoritesManager.shared.saveFavorite(newsItem: currentNewsItem)
            favoriteButton.image = UIImage(systemName: "heart.fill")
        }

        favoriteButton.tintColor = UIColor(hex: "#D6A4A4")
    }

    func setNewsItem(_ item: NewsItem) {
        self.currentNewsItem = item
        updateFavoriteButtonState()
    }

    func displayNews(title: String?, description: String?, imageUrl: String?, pubDate: String?, creator: [String]?) {
        titleLabel.text = title
        descriptionLabel.text = description
        pubDateLabel.text = "Дата: \(pubDate ?? "Не указана")"
        creatorLabel.text = "Автор: \(creator?.joined(separator: ", ") ?? "Не указан")"

        if let imageUrl, let url = URL(string: imageUrl) {
            imageView.loadImage(from: url)
        } else {
            imageView.image = UIImage(named: "defaultImage")
        }

        if let currentNewsItem = currentNewsItem, FavoritesManager.shared.isFavorite(newsItem: currentNewsItem) {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }

        if let link = currentNewsItem?.link, let url = URL(string: link) {
            sourceURL = url
            sourceLinkButton.isHidden = false
        } else {
            sourceLinkButton.isHidden = true
        }
        updateFavoriteButtonState()
    }
    
    @objc private func sourceLinkTapped() {
        guard let url = sourceURL else { return }
        UIApplication.shared.open(url)
    }
    
    private func updateFavoriteButtonState() {
        if let currentNewsItem = currentNewsItem, FavoritesManager.shared.isFavorite(newsItem: currentNewsItem) {
            favoriteButton.image = UIImage(systemName: "heart.fill")
        } else {
            favoriteButton.image = UIImage(systemName: "heart")
        }
    }

}
