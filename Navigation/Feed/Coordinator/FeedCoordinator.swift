//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 21/5/2022.
//

import Foundation
import UIKit

protocol FeedBaseCoordinatorProtocol: CoordinatorProtocol {
    func goToPostScreen()
    func goToInfoScreen()
}

class FeedCoordinator: FeedBaseCoordinatorProtocol {
    
    var parentCoordinator: AppBaseCoordinatorProtocol?
    var rootViewController: UIViewController
    private let feedVC: FeedViewController
    
    init(rootViewController: UIViewController, feedVC: FeedViewController) {
        self.rootViewController = rootViewController
        self.feedVC = feedVC
    }
    
    func start() -> UIViewController {
        feedVC.goToPostsAction = { [weak self] in
            self?.goToPostScreen()
        }
        rootViewController = UINavigationController(rootViewController: feedVC)
        return rootViewController
    }
    
    func goToPostScreen() {
        let postVC = PostViewController()
        postVC.goToInfoAction = { [weak self] in
            self?.goToInfoScreen()
        }
        navigationRootViewController?.pushViewController(postVC, animated: true)
    }
    
    func goToInfoScreen() {
        let infotVC = InfoViewController(viewModel: InfoViewModel().self)
        navigationRootViewController?.present(infotVC, animated: true, completion: nil)
    }  
}
