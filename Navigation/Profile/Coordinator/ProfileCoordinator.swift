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
    var logOutAction: (() -> Void)? { get set }
}

class ProfileCoordinator: ProfileBaseCoordinatorProtocol {
    
    var logOutAction: (() -> Void)?
    
    var loginViewModel: LoginViewModel
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
        self.logOutAction?()
    }
}
