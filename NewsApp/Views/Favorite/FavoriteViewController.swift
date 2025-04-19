//
//  FavoriteNewsViewController.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 17/04/25.
//

import UIKit

protocol FavoriteViewProtocol: AnyObject {
    func displayFavorites(_ news: [NewsItem])
}

class FavoriteViewController: UIViewController, FavoriteViewProtocol {
    
    private var presenter: FavoritePresenterProtocol?
    private var favorites: [NewsItem] = []
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor(hex: "#FAF8F6")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#FAF8F6")
        
        presenter = FavoritePresenter(view: self)
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.viewWillAppear()
    }

    func displayFavorites(_ news: [NewsItem]) {
        self.favorites = news
        tableView.reloadData()
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        guard let item = presenter?.item(at: indexPath.row) else { return cell }
        cell.configure(with: item)
        
        cell.favoriteTapped = { [weak self] in
            self?.presenter?.removeFavorite(at: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let item = presenter?.item(at: indexPath.row) else { return }
        let vc = NewsDetailViewController()
        let presenter = NewsDetailPresenter(view: vc, newsItem: item)
        vc.presenter = presenter
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
