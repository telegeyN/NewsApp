//
//  ViewController.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 17/04/25.
//

import UIKit

protocol AllNewsViewProtocol: AnyObject {
    func displayNews(_ news: [NewsItem])
    func updateFavorite(at index: Int)
}

class AllNewsViewController: UIViewController, AllNewsViewProtocol {

    private var presenter: AllNewsPresenterProtocol?
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsCell.self, forCellReuseIdentifier: NewsCell.identifier)
        tableView.backgroundColor = UIColor(hex: "#FAF8F6")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hex: "#FAF8F6")
        presenter = AllNewsPresenter(view: self)
        
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        presenter?.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    func displayNews(_ news: [NewsItem]) {
        tableView.reloadData()
    }

    func updateFavorite(at index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension AllNewsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.numberOfItems() ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        if let item = presenter?.item(at: indexPath.row) {
            cell.configure(with: item)
        }

        presenter?.loadMoreNewsIfNeeded(at: indexPath.row)
        
        cell.favoriteTapped = { [weak self] in
            self?.presenter?.didTapFavorite(at: indexPath.row)
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
