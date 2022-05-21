//
//  Coordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 20/5/2022.
//

import Foundation
import UIKit

protocol CoordinatorProtocol {
    var rootViewController: UIViewController { get set }
    
    func start() -> UIViewController
}

extension CoordinatorProtocol {
    var navigationRootViewController: UINavigationController? {
        get {
            (rootViewController as? UINavigationController)
        }
    }
}

protocol FlowCoordinatorProtocol {
    
}

