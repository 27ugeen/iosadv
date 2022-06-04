//
//  SceneDelegate.swift
//  Navigation
//
//  Created by GiN Eugene on 19.07.2021.
//

import UIKit
import LocalAuthentication

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let realm = RealmDataProvider()
        let userValidator = LoginPassValidator(provider: realm)
        let localAuthorizationService = LocalAuthorizationService(laContext: LAContext().self)

        let loginVM = LoginViewModel(provider: realm, validator: userValidator)
        let feedVM = FeedViewModel()
        
        let feedVC = FeedViewController(viewModel: feedVM)
        
        let profileCoord = ProfileCoordinator(loginViewModel: loginVM)
        let feedCoord = FeedCoordinator(rootViewController: UIViewController().self, feedVC: feedVC)
        let favoriteCoord = FavoriteCoordinator()
        let mapCoord = MapCoordinator()
        
        let appCoordinator = AppCoordinator(
            loginViewModel: loginVM,
            profileCoordinator: profileCoord,
            feedCoordinator: feedCoord,
            favoriteCoordinator: favoriteCoord,
            mapCoordinator: mapCoord)
        
        let loginVC = LogInViewController(loginViewModel: loginVM, coordinator: appCoordinator, localAuthorizationService: localAuthorizationService)
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        loginNavVC.isNavigationBarHidden = true
        

        profileCoord.logOutAction = {
            UserDefaults.standard.set(false, forKey: "isSignedUp")

            let viewController = LogInViewController(loginViewModel: loginVM, coordinator: appCoordinator, localAuthorizationService: localAuthorizationService)
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

        window?.rootViewController = loginNavVC
    }
}
