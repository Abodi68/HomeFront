//
//  TabBarViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 10/5/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        styleTabBar()
    }

    private func setupTabs() {
        // Instantiate view controllers
        let dashboardVC = DashboardViewController()
        let communityVC = CommunityViewController()
        let resourcesVC = ResourcesViewController()
        let profileVC = ProfileViewController()

        // Wrap each one in a UINavigationController
        let dashboardNav = UINavigationController(rootViewController: dashboardVC)
        let communityNav = UINavigationController(rootViewController: communityVC)
        let resourcesNav = UINavigationController(rootViewController: resourcesVC)
        let profileNav = UINavigationController(rootViewController: profileVC)

        // Assign tab bar items (SF Symbols for clean icons)
        dashboardNav.tabBarItem = UITabBarItem(
            title: "Dashboard",
            image: UIImage(systemName: "house.fill"),
            selectedImage: UIImage(systemName: "house")
        )

        communityNav.tabBarItem = UITabBarItem(
            title: "Community",
            image: UIImage(systemName: "person.3.fill"),
            selectedImage: UIImage(systemName: "person.3")
        )

        resourcesNav.tabBarItem = UITabBarItem(
            title: "Resources",
            image: UIImage(systemName: "book.fill"),
            selectedImage: UIImage(systemName: "book")
        )

        profileNav.tabBarItem = UITabBarItem(
            title: "Profile",
            image: UIImage(systemName: "person.crop.circle.fill"),
            selectedImage: UIImage(systemName: "person.crop.circle")
        )

        // Add them to the tab bar
        viewControllers = [dashboardNav, communityNav, resourcesNav, profileNav]
    }

    private func styleTabBar() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .lightGray
        tabBar.backgroundColor = .systemBackground
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 8
    }
}
