//
//  AppCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 20/5/2022.
//

import Foundation
import UIKit

final class AppCoordinator: AppBaseCoordinatorProtocol {
    //MARK: - props
    
    var parentCoordinator: AppBaseCoordinatorProtocol?
    
    var rootViewController: UIViewController = UITabBarController()
    
    let loginViewModel: LoginViewModel
    let profileCoordinator: ProfileBaseCoordinatorProtocol
    let feedCoordinator: FeedBaseCoordinatorProtocol
    let favoriteCoordinator: FavoriteBaseCoordinatorProtocol
    let mapCoordinator: MapBaseCoordinatorProtocol
    
    //MARK: - init
    init (loginViewModel: LoginViewModel, profileCoordinator: ProfileBaseCoordinatorProtocol, feedCoordinator: FeedBaseCoordinatorProtocol, favoriteCoordinator: FavoriteCoordinator, mapCoordinator: MapBaseCoordinatorProtocol) {
        self.loginViewModel = loginViewModel
        self.profileCoordinator = profileCoordinator
        self.feedCoordinator = feedCoordinator
        self.favoriteCoordinator = favoriteCoordinator
        self.mapCoordinator = mapCoordinator
    }
    
    //MARK: - Localization
    let barProfile = "bar_profile".localized()
    let barFeed = "bar_feed".localized()
    let barFavorite = "bar_favorite".localized()
    let barMap = "bar_map".localized()
    
    //MARK: - methods
    func start() -> UIViewController {
        let feedNavVC = feedCoordinator.start()
        feedCoordinator.parentCoordinator = self
        feedNavVC.tabBarItem = UITabBarItem(title: barFeed, image: UIImage(systemName: "house.fill"), tag: 0)
        
        let profileNavVC = profileCoordinator.start()
        profileCoordinator.parentCoordinator = self
        profileNavVC.tabBarItem = UITabBarItem(title: barProfile, image: UIImage(systemName: "person.fill"), tag: 1)
        
        let favoriteNavVC = favoriteCoordinator.start()
        favoriteCoordinator.parentCoordinator = self
        favoriteNavVC.tabBarItem = UITabBarItem(title: barFavorite, image: UIImage(systemName: "star.square.fill"), tag: 2)
        
        let mapNavVC = mapCoordinator.start()
        mapCoordinator.parentCoordinator = self
        mapNavVC.tabBarItem = UITabBarItem(title: barMap, image: UIImage(systemName: "map.fill"), tag: 3)
        UITabBar.setTransparentTabbar()
        
        (rootViewController as? UITabBarController)?.viewControllers = [profileNavVC, feedNavVC, favoriteNavVC, mapNavVC]
        
        return rootViewController
    }
}
