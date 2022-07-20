//
//  FavoriteCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 21/5/2022.
//

import Foundation
import UIKit

protocol FavoriteBaseCoordinatorProtocol: CoordinatorProtocol {
    func goToSearchView()
}

class FavoriteCoordinator: FavoriteBaseCoordinatorProtocol {
    //MARK: - props
    var parentCoordinator: AppBaseCoordinatorProtocol?
    var rootViewController: UIViewController = UIViewController()
    private let favoriteVC = FavoriteViewController(favoriteViewModel: FavoriteViewModel().self)
    
    //MARK: - methods
    func start() -> UIViewController {
        favoriteVC.goToSearchAction = { [weak self] in
            self?.goToSearchView()
        }
        
        rootViewController = UINavigationController(rootViewController: favoriteVC)
        return rootViewController
    }
    
    func goToSearchView() {
        let searhcVC = FavoriteSearchViewController()
        searhcVC.filterAction = favoriteVC.getFilteredPosts
        navigationRootViewController?.present(searhcVC, animated: true)
    }
}
