//
//  AppBaseCoordinator.swift
//  Navigation
//
//  Created by GiN Eugene on 20/5/2022.
//

import Foundation

protocol AppBaseCoordinatorProtocol: CoordinatorProtocol {
    var profileCoordinator: ProfileBaseCoordinatorProtocol { get }
    var feedCoordinator: FeedBaseCoordinatorProtocol { get }
    var favoriteCoordinator: FavoriteBaseCoordinatorProtocol { get }
    var mapCoordinator: MapBaseCoordinatorProtocol { get }
}


