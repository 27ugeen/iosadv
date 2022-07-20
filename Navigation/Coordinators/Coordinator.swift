//
//  Coordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 20/5/2022.
//

import Foundation
import UIKit

protocol FlowCoordinatorProtocol: AnyObject {
    var parentCoordinator: AppBaseCoordinatorProtocol? { get set }
}

protocol CoordinatorProtocol: FlowCoordinatorProtocol {
    var rootViewController: UIViewController { get set }
    
    func start() -> UIViewController
}
//MARK: - set UINavigationController for current UIViewController
extension CoordinatorProtocol {
    var navigationRootViewController: UINavigationController? {
        get {
            (rootViewController as? UINavigationController)
        }
        set(newValue) {
            rootViewController = newValue ?? UINavigationController().self
        }
    }
}



