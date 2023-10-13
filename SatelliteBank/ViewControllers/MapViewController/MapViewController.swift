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

final private class MapObjectTapListener: NSObject, YMKMapObjectTapListener {
    
    init(controller: IMapViewController) {
        self.controller = controller
    }

    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        guard let placemark = mapObject as? YMKPlacemarkMapObject else { return false }
        self.controller?.didTap(placemark: placemark)
        return true
    }

    private weak var controller: IMapViewController?
    
}

protocol IMapViewController: UIViewController {
    
    func didTap(placemark: YMKPlacemarkMapObject)
    
}

extension MapViewController: IMapViewController {
    
    func didTap(placemark: YMKPlacemarkMapObject) {
        
        guard let office = self.viewModel?
            .officeService
            .offices
            .first(where: {
                $0.coordinate.latitude == placemark.geometry.latitude && $0.coordinate.longitude == placemark.geometry.longitude
            }) else { return }
        
        self.show(office: office)
        
    }
    
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
    
    private lazy var mapObjectTapListener: YMKMapObjectTapListener = MapObjectTapListener(controller: self)
    
    var drivingSession: YMKDrivingSession?
    
    var routesCollection: YMKMapObjectCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViewModel()
        self.setupLocationButton()
        self.layout()
//        self.setupContentViewController()
        self.updateOffice()
        
        self.routesCollection = map.mapObjects.add()
        
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
    
    private func updateOffice() {
        
        self.viewModel?.officeService.update { [weak self] error in
         
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self?.layoutPlacemarks()
            
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

//MARK: - Routes

extension MapViewController {
    
    private func createRoute(toOffice office: IOffice) {
        
//        self.drivingSession?.cancel()
        
        guard let currentLocation = self.currentLocation else { return }
        
        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(
                point: currentLocation.point, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            YMKRequestPoint(
                point: office.coordinate.point, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            ]
        
        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes)
            } else {
                self.onRoutesError(error!)
            }
        }
        
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        
        let drivingOptions = YMKDrivingDrivingOptions()
        drivingOptions.routesCount = 2
        
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: drivingOptions,
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
        
    }
    
    private func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        self.routesCollection.clear()
        
        routes.enumerated().forEach { pair in
            let routePolyline = self.routesCollection.addPolyline(with: pair.element.geometry)
            if pair.offset == 0 {
                routePolyline.styleMainRoute()
            } else {
                routePolyline.styleAlternativeRoute()
            }
        }
        
    }
    
    private func onRoutesError(_ error: Error) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }

        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }
    
}

//MARK: - Presentation

extension MapViewController {
    
    func show(office: IOffice) {
        
        let viewModel = BankContentViewModel(office: office)
        let viewController = BankContentViewController()
        viewController.viewModel = viewModel
        viewController.addRouteCompletion = { [weak self] office in
            self?.createRoute(toOffice: office)
        }

        self.present(viewController, animated: true)
        
    }
    
}

//MARK: - Placemark Office

extension MapViewController {
    
    private func layoutPlacemarks() {
        
        guard let viewModel = self.viewModel else { return }
        
        for office in viewModel.officeService.offices {
            
            self.addPlacemark(office: office)
            
        }
        
    }
    
    private func addPlacemark(office: IOffice) {
        
        let image = UIImage(named: "office_icon_circle")!
        
        let placemark = map.mapObjects.addPlacemark()
        placemark.geometry = office.coordinate.point
        let style = YMKIconStyle(anchor: nil, rotationType: nil, zIndex: nil, flat: nil, visible: nil, scale: 0.6, tappableArea: nil)
        placemark.setIconWith(image, style: style)
        placemark.isDraggable = true

        placemark.addTapListener(with: mapObjectTapListener)
        
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
