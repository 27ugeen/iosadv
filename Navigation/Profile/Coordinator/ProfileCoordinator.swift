//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 21/5/2022.
//

import Foundation
import UIKit
import iOSIntPackage

protocol ProfileBaseCoordinatorProtocol: CoordinatorProtocol {
    func goToPhotosGallery()
    func logOut()
    var logOutAction: (() -> Void)? { get set }
}

class ProfileCoordinator: ProfileBaseCoordinatorProtocol {
    //MARK: - props
    var parentCoordinator: AppBaseCoordinatorProtocol?
    var rootViewController: UIViewController
    private let loginViewModel: LoginViewModel
    private let profileVC: ProfileViewController
    
    var logOutAction: (() -> Void)?
    
    //MARK: - init
    init(rootViewController: UIViewController, loginViewModel: LoginViewModel, profileVC: ProfileViewController) {
        self.rootViewController = rootViewController
        self.loginViewModel = loginViewModel
        self.profileVC = profileVC
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
        let imgPubFascade = ImagePublisherFacade()
        let photosVC = PhotosViewController(imagePublisherFacade: imgPubFascade)
        navigationRootViewController?.pushViewController(photosVC, animated: true)
    }
    
    func logOut() {
        self.logOutAction?()
    }
}
