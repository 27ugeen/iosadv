//
//  MapCoordinatorTests.swift
//  NavigationTests
//
//  Created by GiN Eugene on 22/7/2022.
//

import Quick
import Nimble
@testable import Navigation

class MapCoordinatorTests: QuickSpec {
    
    private var mapVC: MapViewController!
    private var mapView: MKMapViewMock!
    private var locationManager: CLLocationManagerMok!
    private var viewController: UIViewControllerMock!
    private var mapCoordinator: MapCoordinator!
    private var navigationController: UINavigationControllerMock!
    
    override func spec() {
        self.mapView = MKMapViewMock()
        self.locationManager = CLLocationManagerMok()
        self.mapVC = MapViewController(mapView: self.mapView, locationManager: self.locationManager)
        self.viewController = UIViewControllerMock()
        self.mapCoordinator = MapCoordinator(rootViewController: self.viewController, mapVC: self.mapVC)
        self.navigationController = UINavigationControllerMock(rootViewController: self.mapVC)
        
        //MARK: - start() testing
        describe("start() testing") {
            context("when func started") {
                it("expect return mapVC as rootVC") {
                    let actual = self.mapCoordinator.start()
                    
                    expect(actual).to(beAKindOf(UINavigationController.self))
                    expect(actual.isViewLoaded).to(equal(true))
                }
            }
        }
    }
}
