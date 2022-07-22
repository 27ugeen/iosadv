//
//  FavoriteCoordinatorTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 22/7/2022.
//

import Quick
import Nimble
@testable import Navigation

class FavoriteCoordinatorTests: QuickSpec {
    
    private var favViewModel: FavoriteViewModel!
    private var favVC: FavoriteViewController!
    private var viewController: UIViewControllerMock!
    private var favCoordinator: FavoriteCoordinator!
    private var navigationController: UINavigationControllerMock!
    
    override func spec() {
        self.favViewModel = FavoriteViewModel()
        self.favVC = FavoriteViewController(favoriteViewModel: self.favViewModel)
        self.viewController = UIViewControllerMock()
        self.favCoordinator = FavoriteCoordinator(rootViewController: self.viewController, favoriteVC: self.favVC)
        self.navigationController = UINavigationControllerMock(rootViewController: self.favVC)
        
        //MARK: - start() testing
        describe("start() testing") {
            context("when func started") {
                it("expect return favVC as rootVC") {
                    let actual = self.favCoordinator.start()
                    let res = self.favVC.goToSearchAction
                    
                    expect(res).to(beAKindOf((() -> Void).self))
                    expect(actual).to(beAKindOf(UINavigationController.self))
                    expect(actual.isViewLoaded).to(equal(true))
                }
            }
        }
        //MARK: - goToSearchView() testing
        describe("goToSearchView() testing") {
            context("when func started") {
                beforeEach {
                    self.navigationController.presentCalled = false
                    self.favCoordinator.navigationRootViewController = self.navigationController
                }
                it("then expect present FavoriteSearchVC") {
                    self.favCoordinator.goToSearchView()
                    
                    expect(self.navigationController.presentCalled).to(equal(true))
                }
            }
        }
    }
}
