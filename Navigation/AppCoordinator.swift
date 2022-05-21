//
//  AppCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 20/5/2022.
//

import Foundation
import UIKit

final class AppCoordinator: AppBaseCoordinatorProtocol {
    var rootViewController: UIViewController = UITabBarController()
    
    //MARK: - Localization
    let barProfile = "bar_profile".localized()
    let barFeed = "bar_feed".localized()
    let barFavorite = "bar_favorite".localized()
    let barMap = "bar_map".localized()
    
    //MARK: - methods
    func start() -> UIViewController {
        let feedVC = FeedViewController(viewModel: FeedViewModel().self)
        let feedNavVC = UINavigationController(rootViewController: feedVC)
        feedNavVC.tabBarItem = UITabBarItem(title: barFeed, image: UIImage(systemName: "house.fill"), tag: 0)
        
        let profileVC = ProfileViewController(profileViewModel: ProfileViewModel().self)
        let profileNavVC = UINavigationController(rootViewController: profileVC)
        profileNavVC.tabBarItem = UITabBarItem(title: barProfile, image: UIImage(systemName: "person.fill"), tag: 1)
        profileNavVC.isNavigationBarHidden = true
        
        let favoriteVC = FavoriteViewController(favoriteViewModel: FavoriteViewModel().self)
        let favoriteNavVC = UINavigationController(rootViewController: favoriteVC)
        favoriteNavVC.tabBarItem = UITabBarItem(title: barFavorite, image: UIImage(systemName: "star.square.fill"), tag: 2)
        
        let mapVC = MapViewController()
        let mapNavVC = UINavigationController(rootViewController: mapVC)
        mapNavVC.tabBarItem = UITabBarItem(title: barMap, image: UIImage(systemName: "map.fill"), tag: 3)
        mapNavVC.isNavigationBarHidden = true
        UITabBar.setTransparentTabbar()
        
        (rootViewController as? UITabBarController)?.viewControllers = [profileNavVC, feedNavVC, favoriteNavVC, mapNavVC]
        
        return rootViewController
    }
}
