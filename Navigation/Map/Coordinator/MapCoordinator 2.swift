//
//  MapCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 21/5/2022.
//

import Foundation
import UIKit

protocol MapBaseCoordinatorProtocol: CoordinatorProtocol {
    func goAnywhere()
}

class MapCoordinator: MapBaseCoordinatorProtocol {
    func goAnywhere() {
        print("future func")
    }
    
    var parentCoordinator: AppBaseCoordinatorProtocol?
    var rootViewController: UIViewController = UIViewController()
    
    private let mapVC = MapViewController()
    
    func start() -> UIViewController {
        return UINavigationController(rootViewController: mapVC)
    }
}
