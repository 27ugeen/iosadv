//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 21/5/2022.
//

import Foundation
import UIKit

protocol ProfileBaseCoordinatorProtocol: CoordinatorProtocol {
    func goToPhotosGallery()
    func logOut()
}

class ProfileCoordinator: ProfileBaseCoordinatorProtocol {
    
    var loginViewModel: LoginViewModel
    weak var appCoordinator: AppCoordinator?
    var parentCoordinator: AppBaseCoordinatorProtocol?
    var rootViewController: UIViewController = UIViewController()
    private let profileVC = ProfileViewController(profileViewModel: ProfileViewModel().self)
    
    init (loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    
    
    func start() -> UIViewController {
        profileVC.goToPhotoGalleryAction = { [weak self] in
            self?.goToPhotosGallery()
        }
        
        profileVC.logOutAction = { [weak self] in
            self?.logOut()
        }
        
        rootViewController = UINavigationController(rootViewController: profileVC)
        return rootViewController
    }
    
    func goToPhotosGallery() {
        let photosVC = PhotosViewController()
        navigationRootViewController?.pushViewController(photosVC, animated: true)
    }
    
    func logOut() {
        UserDefaults.standard.set(false, forKey: "isSignedUp")
        
        let viewController = LogInViewController(loginViewModel: self.loginViewModel, coordinator: AppCoordinator(loginViewModel: self.loginViewModel).self)
        let navCtrl = UINavigationController(rootViewController: viewController)

        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first,
            let rootViewController = window.rootViewController
        else {
            return
        }

        navCtrl.view.frame = rootViewController.view.frame
        navCtrl.view.layoutIfNeeded()

        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navCtrl
        })
        
        print("User is signed out!")
    }
    
}
