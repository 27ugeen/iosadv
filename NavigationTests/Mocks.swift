//
//  Mocks.swift
//  NavigationTests
//
//  Created by GiN Eugene on 22/7/2022.
//

import Quick
import Nimble
import MapKit
@testable import Navigation

final class UIViewControllerMock: UIViewController {}
final class MKMapViewMock: MKMapView {}
final class CLLocationManagerMock: CLLocationManager {}

final class UINavigationControllerMock: UINavigationController {
    var pushViewControllerCalled = false
    var instanceVC: UIViewController?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        instanceVC = viewController
        pushViewControllerCalled = true
    }
    
    var presentCalled = false
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        super.present(viewControllerToPresent, animated: flag, completion: completion)
        presentCalled = true
    }
}

class DataBaseManagerMock: DataBaseManager {}

class DataProviderMock: DataProvider {
    
    weak var delegate: DataProviderDelegate?
    var shouldGetUserResponse: User?
    
    func getUserById(id: String) -> User? {
        return shouldGetUserResponse ?? nil
    }
    
    func getUserByLogin(login: String) -> User? {
        return shouldGetUserResponse ?? nil
    }
    
    func createUser(_ user: User) {}
    func updateUser(_ user: User) {}
    func deleteUser(_ user: User) {}
}
