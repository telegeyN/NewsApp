//
//  ViewController.swift
//  NewsApp
//
//  Created by Telegey Nurbekova on 17/04/25.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarController()
        tabBar.backgroundColor = UIColor(hex: "#FFFFFF")
        tabBar.tintColor = UIColor(hex: "#D6A4A4")
        tabBar.unselectedItemTintColor = UIColor(hex: "#9A9A9A")
        tabBar.barTintColor = UIColor(hex: "#FFFFFF")
        addTabBarBorder()
        NotificationCenter.default.addObserver(self, selector: #selector(switchToTab(_:)), name: NSNotification.Name("SwitchToTab"), object: nil)
    }
    
    @objc func switchToTab(_ notification: Notification) {
        if let userInfo = notification.userInfo, let tabIndex = userInfo["tabIndex"] as? Int {
            self.selectedIndex = tabIndex
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("SwitchToTab"), object: nil)
    }
    
    private func addTabBarBorder() {
        let borderView = UIView()
        borderView.backgroundColor = UIColor.white
        borderView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(borderView)
        
        NSLayoutConstraint.activate([
            borderView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            borderView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            borderView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            borderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupTabBarController() {
        
        let allNewsView = UINavigationController(rootViewController: AllNewsViewController())
        allNewsView.tabBarItem = UITabBarItem(title: "Все новости", image: UIImage(systemName: "newspaper"), tag: 0)
        allNewsView.navigationBar.isHidden = true
        
        let favoriteNewsView = FavoriteViewController()
        favoriteNewsView.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "heart"), tag: 1)
        
        setViewControllers([allNewsView, favoriteNewsView], animated: true)
    }
}
