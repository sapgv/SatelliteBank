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

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .tip
    let anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] = [
        .full: FloatingPanelLayoutAnchor(absoluteInset: 16.0, edge: .top, referenceGuide: .safeArea),
//        .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
        .tip: FloatingPanelLayoutAnchor(absoluteInset: 88.0, edge: .bottom, referenceGuide: .safeArea),
    ]
}

class MapViewController: UIViewController {
    
    var viewModel: IMapViewModel?
    
    private var fpc: FloatingPanelController!
    
    private lazy var locationMapButton: CurrentLocationMapButton = CurrentLocationMapButton()
    
    private lazy var scaleMapStackView: ScaleMapStackView = ScaleMapStackView()
    
    private var scalePlusMapButton: ScalePlusMapButton {
        self.scaleMapStackView.scalePlusMapButton
    }

    private var scaleMinusMapButton: ScaleMinusMapButton {
        self.scaleMapStackView.scaleMinusMapButton
    }

    private let mapView: YMKMapView = YMKMapView()
    
    private var map: YMKMap {
        self.mapView.mapWindow.map
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViewModel()
        self.setupLocationButton()
        self.layout()
        self.setupContentViewController()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel?.locationManager.requestWhenInUseAuthorization()
        self.viewModel?.requestLocation()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel?.locationManager.stopUpdatingLocation()
    }

    private func setupViewModel() {
        
        self.viewModel?.requestLocationCompletion = { [weak self] location in
            
            self?.currentLocation = location
            self?.updateCurrentLocation(location: location)
            
        }
        
    }
    
    private func setupContentViewController() {
        
        self.fpc = FloatingPanelController()
        
        self.fpc.layout = MyFloatingPanelLayout()
        
        // Set a content view controller.
        let contentVC = MapContentViewController()
        contentVC.delegate = self
        
        let navigationController = UINavigationController(rootViewController: contentVC)
        
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 16
        fpc.surfaceView.appearance = appearance
        
        self.fpc.set(contentViewController: navigationController)
        
        self.fpc.addPanel(toParent: self)
        
    }
    
    
    
    private func setupLocationButton() {
        
        self.locationMapButton.action = { [weak self] _ in
            self?.moveToCurrentLocation()
        }
        
        self.scalePlusMapButton.action = { [weak self] _ in
            
            self?.map.scaleMap(value: 1)
            
        }
        
        self.scaleMinusMapButton.action = { [weak self] _ in
            
            self?.map.scaleMap(value: -1)
            
            
        }
        
    }
    
    private let locationArrowButtonSize: CGFloat = 48
    
    
    
    private let locationArrowButtonPadding: CGFloat = 88 + 16
    
    private lazy var currentLocationPlacemark: YMKPlacemarkMapObject = {
        
        let image = UIImage(named: "location")!
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

extension MapViewController: ContentViewControllerDelegate {
    
    func searchBarTextDidBeginEditing() {
        fpc.move(to: .full, animated: true)
    }
    
}

//MARK: - Layout

extension MapViewController {
    
    private func layout() {
        
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.scaleMapStackView.translatesAutoresizingMaskIntoConstraints = false
        self.scaleMapStackView.scalePlusMapButton.translatesAutoresizingMaskIntoConstraints = false
        self.scaleMapStackView.scaleMinusMapButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.scaleMapStackView)
        

        self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        self.locationMapButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.locationMapButton)
        
        self.locationMapButton.widthAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        self.locationMapButton.heightAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        
        self.locationMapButton.layer.cornerRadius = locationArrowButtonSize / 2
        self.locationMapButton.clipsToBounds = true
        
        self.locationMapButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.locationMapButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -locationArrowButtonPadding).isActive = true
     
        
        self.scaleMapStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.scaleMapStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        
        self.scaleMapStackView.scalePlusMapButton.widthAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        self.scaleMapStackView.scalePlusMapButton.heightAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        self.scaleMapStackView.scaleMinusMapButton.widthAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        self.scaleMapStackView.scaleMinusMapButton.heightAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
        
        self.scaleMapStackView.scalePlusMapButton.layer.cornerRadius = locationArrowButtonSize / 2
        self.scaleMapStackView.scalePlusMapButton.clipsToBounds = true
        
        self.scaleMapStackView.scaleMinusMapButton.layer.cornerRadius = locationArrowButtonSize / 2
        self.scaleMapStackView.scaleMinusMapButton.clipsToBounds = true
        
        
    }
    
}
