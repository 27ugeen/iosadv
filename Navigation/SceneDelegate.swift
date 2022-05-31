//
//  SceneDelegate.swift
//  Navigation
//
//  Created by GiN Eugene on 19.07.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let realm = RealmDataProvider()
        let userValidator = LoginPassValidator(provider: realm)

        let loginViewModel = LoginViewModel(provider: realm, validator: userValidator)
        let appCoordinator = AppCoordinator(loginViewModel: loginViewModel)
        
        let loginVC = LogInViewController(loginViewModel: loginViewModel, coordinator: appCoordinator)
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        loginNavVC.isNavigationBarHidden = true

        window?.rootViewController = loginNavVC
    }
}
