//
//  MapViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit
import YandexMapsMobile
import CoreLocation
import FloatingPanel

class MapViewController: UIViewController {
    
    var fpc: FloatingPanelController!
    
    private var locationArrowButton: LocationArrowButton = LocationArrowButton()

    var locationViewModel: ILocationViewModel?
    
    private let mapView: YMKMapView = YMKMapView()
    
    private var map: YMKMap {
        self.mapView.mapWindow.map
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray
        self.layout()
        self.setupViewModel()
        self.setupCurrentLocationButton()
        
        
        fpc = FloatingPanelController()
        
        // Assign self as the delegate of the controller.
//        fpc.delegate = self // Optional
        
        // Set a content view controller.
        let contentVC = ContentViewController()
        contentVC.delegate = self
        
        let navigationController = UINavigationController(rootViewController: contentVC)
        
        fpc.set(contentViewController: navigationController)
        
        // Track a scroll view(or the siblings) in the content view controller.
//        fpc.track(scrollView: contentVC.tableView)
        
        // Add and show the views managed by the `FloatingPanelController` object to self.view.
        fpc.addPanel(toParent: self)
        
//        self.present(fpc, animated: true, completion: nil)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationViewModel?.requestLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.locationViewModel?.locationManager.stopUpdatingLocation()
    }

    private func setupViewModel() {
        
        self.locationViewModel?.requestLocationCompletion = { [weak self] location in
            
            self?.currentLocation = location
            self?.updateCurrentLocation(location: location)
            
            
        }
        
    }
    
    private func setupCurrentLocationButton() {
        
        self.locationArrowButton.backgroundColor = .white
        self.locationArrowButton.action = { [weak self] _ in
            self?.moveToCurrentLocation()
        }
        
    }
    
    private let locationArrowButtonSize: CGFloat = 48
    
    private func layout() {
        
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(self.mapView)
//
//        self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
//        self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
//        self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
//        self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
//
//        self.locationArrowButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.locationArrowButton)
        
        self.locationArrowButton.widthAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        self.locationArrowButton.heightAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        
        self.locationArrowButton.layer.cornerRadius = locationArrowButtonSize / 2
        self.locationArrowButton.clipsToBounds = true
        
        self.locationArrowButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.locationArrowButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
    }
    
//    private func addPlacemark() {
//        let image = UIImage(named: "vtb_lines")!
//        let point = YMKPoint(latitude: 59.935493, longitude: 30.327392)
//        let placemark = map.mapObjects.addPlacemark()
//        placemark.setIconWith(image)
////        placemark.setIconStyleWith(.)
////        placemark.setIconStyleWith(.init(anchor: nil, rotationType: nil, zIndex: nil, flat: nil, visible: 1, scale: 0.1, tappableArea: nil))
//        placemark.geometry = point
//
//
//
//    }
    
    private lazy var currentLocationPlacemark: YMKPlacemarkMapObject = {
        
        let image = UIImage(named: "location")!.withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
        let placemark = map.mapObjects.addPlacemark()
        placemark.setIconWith(image)
            
        return placemark
        
    }()
    
    private var currentLocation: CLLocation? {
        didSet {
            guard !initialMovedCurrent else { return }
            self.moveToCurrentLocation()
            self.initialMovedCurrent = true
        }
    }
    
    private var initialMovedCurrent: Bool = false
    
    private func moveToCurrentLocation() {
        guard let currentLocation = self.currentLocation else { return }
        
        let cameraPosition = YMKCameraPosition(target:currentLocation.point, zoom: 14, azimuth: 0, tilt: 0)
        
        mapView.mapWindow.map.move(with: cameraPosition)
        
    }
    
    private func updateCurrentLocation(location: CLLocation) {
        
        let point = YMKPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        self.currentLocationPlacemark.geometry = point
        
    }
    
}

extension CLLocation {
    
    var point: YMKPoint {
        return YMKPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
    
}

extension MapViewController: ContentViewControllerDelegate {
    
    func searchBarTextDidBeginEditing() {
        fpc.move(to: .full, animated: true)
    }
    
}
