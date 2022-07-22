//
//  ProfileCoordinatorTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 22/7/2022.
//

import Quick
import Nimble
@testable import Navigation

class ProfileCoordinatorTests: QuickSpec {
    
    private var dataProvider: DataProviderMock!
    private var validator: LoginPassValidator!
    
    private var loginViewModel: LoginViewModel!
    private var profileViewModel: ProfileViewModel!
    private var profileVC: ProfileViewController!
    private var profileCoordinator: ProfileCoordinator!
    private var viewController: UIViewControllerMock!
    private var navigationController: UINavigationControllerMock!
    
    override func spec() {
        self.dataProvider = DataProviderMock()
        self.validator = LoginPassValidator(provider: self.dataProvider)
        
        self.loginViewModel = LoginViewModel(provider: self.dataProvider, validator: self.validator)
        self.profileViewModel = ProfileViewModel()
        self.profileVC = ProfileViewController(profileViewModel: self.profileViewModel)
        self.viewController = UIViewControllerMock()
        self.profileCoordinator = ProfileCoordinator(rootViewController: self.viewController, loginViewModel: self.loginViewModel, profileVC: self.profileVC)
        self.navigationController = UINavigationControllerMock(rootViewController: self.profileVC)
        
        //MARK: - start() testing
        describe("start() testing") {
            context("when func started") {
                it("then expect return profileVC as rootVC") {
                    let actual = self.profileCoordinator.start()
                    let resGoTo = self.profileVC.goToPhotoGalleryAction
                    let resLogOut = self.profileVC.logOutAction
                    
                    expect(resGoTo).to(beAKindOf((() -> Void).self))
                    expect(resLogOut).to(beAKindOf((() -> Void).self))
                    expect(actual).to(beAKindOf(UINavigationController.self))
                    expect(actual.isViewLoaded).to(equal(true))
                }
            }
        }
        //MARK: - goToPhotosGallery() testing
        describe("goToPhotosGallery() testing") {
            context("when func started") {
                beforeEach {
                    self.navigationController.pushViewControllerCalled = false
                    self.profileCoordinator.navigationRootViewController = self.navigationController
                }
                it("then expect push vc to PhotosVC") {
                    self.profileCoordinator.goToPhotosGallery()
                    
                    expect(self.navigationController.instanceVC).to(beAKindOf(PhotosViewController.self))
                    expect(self.navigationController.pushViewControllerCalled).to(equal(true))
                }
            }
        }
        //MARK: - logOut() testing
        describe("logOut() testing") {
            context("when func started") {
                it("then expect execute logOut") {
                    let actual: () = self.profileCoordinator.logOut()
                    
                    expect(actual).to(beVoid())
                }
            }
        }
    }
}
