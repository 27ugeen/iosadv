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
    //MARK: - props
    var parentCoordinator: AppBaseCoordinatorProtocol?
    var rootViewController: UIViewController = UIViewController()
    private let loginViewModel: LoginViewModel
    private let profileVC = ProfileViewController(profileViewModel: ProfileViewModel().self)
    
    var logOutAction: (() -> Void)?
    
    //MARK: - init
    init (loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
    }
    //MARK: - methods
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
