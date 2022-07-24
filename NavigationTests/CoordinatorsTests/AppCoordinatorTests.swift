//
//  AppCoordinatorTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 22/7/2022.
//

import Quick
import Nimble
@testable import Navigation

class AppCoordinatorTests: QuickSpec {
    private var viewController: UIViewControllerMock!
    
    private var mapView: MKMapViewMock!
    private var locationManager: CLLocationManagerMock!
    
    private var dataProvider: DataProviderMock!
    private var validator: LoginPassValidator!
    
    private var loginVM: LoginViewModel!
    private var profileVM: ProfileViewModel!
    private var feedVM: FeedViewModel!
    private var favVM: FavoriteViewModel!
    
    private var profileVC: ProfileViewController!
    private var feedVC: FeedViewController!
    private var favVC: FavoriteViewController!
    private var mapVC: MapViewController!
    
    private var profileCoord: ProfileCoordinator!
    private var feedCoord: FeedCoordinator!
    private var favCoord: FavoriteCoordinator!
    private var mapCoord: MapCoordinator!
    
    private var appCoordinator: AppCoordinator!
    
    override func spec() {
        self.viewController = UIViewControllerMock()
        
        self.mapView = MKMapViewMock()
        self.locationManager = CLLocationManagerMock()
        
        self.dataProvider = DataProviderMock()
        self.validator = LoginPassValidator(provider: self.dataProvider)
        
        self.loginVM = LoginViewModel(provider: self.dataProvider, validator: self.validator)
        self.profileVM = ProfileViewModel()
        self.feedVM = FeedViewModel()
        self.favVM = FavoriteViewModel()
        
        self.profileVC = ProfileViewController(profileViewModel: self.profileVM)
        self.feedVC = FeedViewController(viewModel: self.feedVM)
        self.favVC = FavoriteViewController(favoriteViewModel: self.favVM)
        self.mapVC = MapViewController(mapView: self.mapView, locationManager: self.locationManager)
        
        self.profileCoord = ProfileCoordinator(rootViewController: self.viewController, loginViewModel: loginVM.self, profileVC: self.profileVC)
        self.feedCoord = FeedCoordinator(rootViewController: self.viewController, feedVC: self.feedVC)
        self.favCoord = FavoriteCoordinator(rootViewController: self.viewController, favoriteVC: self.favVC)
        self.mapCoord = MapCoordinator(rootViewController: self.viewController, mapVC: mapVC)
        
        self.appCoordinator = AppCoordinator(profileCoordinator: self.profileCoord, feedCoordinator: self.feedCoord, favoriteCoordinator: self.favCoord, mapCoordinator: self.mapCoord)
        
        //MARK: - start() testing
        describe("start() testing") {
            context("when func started") {
                it("expect return tabBarVC as rootVC") {
                    let actual = self.appCoordinator.start()

                    expect(actual).to(beAKindOf(UITabBarController.self))
                    expect(actual.isViewLoaded).to(equal(true))
                }
            }
        }
    }
}

