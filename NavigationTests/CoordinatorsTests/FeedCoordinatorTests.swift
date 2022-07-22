//
//  FeedCoordinatorTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 1/6/2022.
//

import Quick
import Nimble
@testable import Navigation

class FeedCoordinatorTests: QuickSpec {
    
    private var feedViewModel: FeedViewModel!
    private var feedVC: FeedViewController!
    private var viewController: UIViewControllerMock!
    private var feedCoordinator: FeedCoordinator!
    private var navigationController: UINavigationControllerMock!
    
    override func spec() {
        self.feedViewModel = FeedViewModel()
        self.feedVC = FeedViewController(viewModel: self.feedViewModel)
        self.viewController = UIViewControllerMock()
        self.feedCoordinator = FeedCoordinator(rootViewController: self.viewController, feedVC: self.feedVC)
        self.navigationController = UINavigationControllerMock(rootViewController: self.feedVC)
        
        //MARK: - start() testing
        describe("start() testing") {
            context("when func started") {
                it("expect return feedVC as rootVC") {
                    let actual = self.feedCoordinator.start()
                    let res = self.feedVC.goToPostsAction
                    
                    expect(res).to(beAKindOf((() -> Void).self))
                    expect(actual).to(beAKindOf(UINavigationController.self))
                    expect(actual.isViewLoaded).to(equal(true))
                }
            }
        }
        //MARK: - goToPostScreen() testing
        describe("goToPostScreen() testing") {
            context("when func started") {
                beforeEach {
                    self.navigationController.pushViewControllerCalled = false
                    self.feedCoordinator.navigationRootViewController = self.navigationController
                }
                it("expect push vc to PostVC") {
                    self.feedCoordinator.goToPostScreen()
                    
                    expect(self.navigationController.instanceVC).to(beAKindOf(PostViewController.self))
                    expect(self.navigationController.pushViewControllerCalled).to(equal(true))
                }
            }
        }
        //MARK: - goToInfoScreen() testing
        describe("goToInfoScreen() testing") {
            context("when func started") {
                beforeEach {
                    self.navigationController.presentCalled = false
                    self.feedCoordinator.navigationRootViewController = self.navigationController
                }
                it("then expect push to InfoVC") {
                    self.feedCoordinator.goToInfoScreen()
                    
                    expect(self.navigationController.presentCalled).to(equal(true))
                }
            }
        }
    }
}
