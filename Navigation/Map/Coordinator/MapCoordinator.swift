//
//  MapCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 21/5/2022.
//

import Foundation
import UIKit

protocol MapBaseCoordinatorProtocol: CoordinatorProtocol {}

class MapCoordinator: MapBaseCoordinatorProtocol {
    //MARK: - props
    var parentCoordinator: AppBaseCoordinatorProtocol?
    var rootViewController: UIViewController
    private let mapVC: MapViewController
    
    //MARK: - init
    init(rootViewController: UIViewController, mapVC: MapViewController) {
        self.rootViewController = rootViewController
        self.mapVC = mapVC
    }
    //MARK: - methods
    func start() -> UIViewController {
        return UINavigationController(rootViewController: mapVC)
    }
}
