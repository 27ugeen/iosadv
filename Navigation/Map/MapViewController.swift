//
//  MapViewController.swift
//  Navigation
//
//  Created by GiN Eugene on 16/4/2022.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    private lazy var mapView = MKMapView()
    private var userAnnotations = [MKPointAnnotation]()
    private lazy var locationManager = CLLocationManager()
    
    private lazy var deletePinsButton = MagicButton(title: "Delete pins", titleColor: .white) {
        self.deletePins()
    }
    
    private lazy var longGesture = UILongPressGestureRecognizer(target: self, action: #selector(addWayPoint))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupDelPinsButton()
        checkUserLocationPermissions()
    }
    //MARK: - @objc methods
    
    @objc private func addWayPoint(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = longGesture.location(in: mapView)
            let pointCoords = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let wayAnnotation = MKPointAnnotation()
            wayAnnotation.coordinate = pointCoords
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: pointCoords.latitude, longitude: pointCoords.longitude)) { (placemarks, error) -> Void in
                if let unwrError = error as? NSError {
                    print("Reverse geocoder failed with error" + unwrError.localizedDescription)
                    return
                }
                
                if let unwrPlacemarks = placemarks {
                    if unwrPlacemarks.count > 0 {
                        let pm = unwrPlacemarks[0]
                        wayAnnotation.title = (pm.thoroughfare ?? "") + ", " + (pm.subThoroughfare ?? "")
                        wayAnnotation.subtitle = pm.subLocality
                        
                        self.mapView.addAnnotation(wayAnnotation)
                    } else {
                        wayAnnotation.title = "Unknown Place"
                        self.mapView.addAnnotation(wayAnnotation)
                        print("Problem with the data received from geocoder")
                    }
                    self.userAnnotations.append(wayAnnotation)
                }
            }
        }
    }
}
//MARK: - setup delPinsButton

extension MapViewController {
    private func setupDelPinsButton() {
        deletePinsButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        deletePinsButton.setTitleColor(.systemRed , for: .highlighted)
        deletePinsButton.setTitleColor(.systemRed , for: .selected)
        deletePinsButton.backgroundColor = .systemBlue
        deletePinsButton.layer.cornerRadius = 10
        deletePinsButton.clipsToBounds = true
    }
}
//MARK: - setup MapView

extension MapViewController {
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.addGestureRecognizer(longGesture)
        mapView.delegate = self
        
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        
        view.addSubview(mapView)
        mapView.addSubview(deletePinsButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            deletePinsButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -46),
            deletePinsButton.bottomAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.bottomAnchor),
            deletePinsButton.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
}
//MARK: - check UserLocationPermissions

extension MapViewController {
    private func checkUserLocationPermissions() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = 100
        locationManager.startUpdatingLocation()
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied, .restricted:
            showAlert(message: "Please, set permission for your location in settings")
        case .authorizedAlways, .authorizedWhenInUse:
            mapView.showsUserLocation = true
        @unknown default:
            fatalError("Unknown status")
        }
    }
}
//MARK: - methods

extension MapViewController {
    private func addRoute(_ destinationPoint: CLLocationCoordinate2D) {
        let directionRequest = MKDirections.Request()
        
        let sourcePlaceMark = MKPlacemark(coordinate: destinationPoint)
        let sourceMapItem = MKMapItem(placemark: sourcePlaceMark)
        
        let destinationPlaceMark = MKPlacemark(coordinate: locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
        let destinationMapItem = MKMapItem(placemark: destinationPlaceMark)
        
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] response, error -> Void in
            guard let self = self else { return }
            
            guard let response = response else {
                if let error = error as? NSError {
                    print(error)
                    self.showAlert(message: error.localizedDescription)
                }
                return
            }
            let route = response.routes[0]
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)
        }
    }
    
    private func deletePins() {
        self.mapView.removeOverlays(self.mapView.overlays)
        self.mapView.removeAnnotations(userAnnotations)
    }
    
    private func showAlertOkCancel(_ props: CLLocationCoordinate2D) {
        let alertVC = UIAlertController(title: "Make a choice", message: "Do you want to make a route to this point?", preferredStyle: UIAlertController.Style.alert)
        
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.mapView.removeOverlays(self.mapView.overlays)
            self.addRoute(props)
        }))
        alertVC.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.present(alertVC, animated: true, completion: nil)
    }
}
//MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserLocationPermissions()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 3000, longitudinalMeters: 3000)
        mapView.setRegion(region, animated: true)
    }
}
//MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 5.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let unwrAnnotation = view.annotation {
            self.showAlertOkCancel(unwrAnnotation.coordinate)
        }
    }
}
