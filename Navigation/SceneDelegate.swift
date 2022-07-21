//
//  SceneDelegate.swift
//  Navigation
//
//  Created by GiN Eugene on 19.07.2021.
//

import UIKit
import LocalAuthentication
import MapKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        window?.makeKeyAndVisible()
        
        let localAuthContext = LAContext()
        let mapView = MKMapView()
        let locationManager = CLLocationManager()
        let rootVC = UIViewController()
        
        let realm = RealmDataProvider()
        let userValidator = LoginPassValidator(provider: realm)
        let localAuthorizationService = LocalAuthorizationService(laContext: localAuthContext)
        

        let loginVM = LoginViewModel(provider: realm, validator: userValidator)
        
        let feedVM = FeedViewModel()
        let feedVC = FeedViewController(viewModel: feedVM)
        
        let profileVM = ProfileViewModel()
        let profileVC = ProfileViewController(profileViewModel: profileVM)
        
        let favVM = FavoriteViewModel()
        let favVC = FavoriteViewController(favoriteViewModel: favVM)
        
        let mapVC = MapViewController(mapView: mapView, locationManager: locationManager)
        
        let profileCoord = ProfileCoordinator(rootViewController: rootVC,
                                              loginViewModel: loginVM,
                                              profileVC: profileVC)
        
        let feedCoord = FeedCoordinator(rootViewController: rootVC, feedVC: feedVC)
        let favoriteCoord = FavoriteCoordinator(rootViewController: rootVC, favoriteVC: favVC)
        let mapCoord = MapCoordinator(rootViewController: rootVC, mapVC: mapVC)
        
        let appCoordinator = AppCoordinator(profileCoordinator: profileCoord,
                                            feedCoordinator: feedCoord,
                                            favoriteCoordinator: favoriteCoord,
                                            mapCoordinator: mapCoord)
        
        let loginVC = LogInViewController(loginViewModel: loginVM,
                                          coordinator: appCoordinator,
                                          localAuthorizationService: localAuthorizationService)
        
        let notifCenter = UNUserNotificationCenter.current()
        notifCenter.delegate = loginVC
        
        let loginNavVC = UINavigationController(rootViewController: loginVC)
        
        profileCoord.logOutAction = {
            UserDefaults.standard.set(false, forKey: "isSignedUp")

            let viewController = LogInViewController(loginViewModel: loginVM,
                                                     coordinator: appCoordinator,
                                                     localAuthorizationService: localAuthorizationService)
            
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

            UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navCtrl
            })
            print("User is signed out!")
        }
        window?.rootViewController = loginNavVC
    }
}
