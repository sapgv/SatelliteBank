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

protocol IMapViewController: UIViewController {
    
    func didTap(placemark: YMKPlacemarkMapObject)
    
}

extension MapViewController: IMapViewController {
    
    func didTap(placemark: YMKPlacemarkMapObject) {
        
        if let office = self.viewModel?
            .officeService
            .offices
            .first(where: {
                $0.coordinate == placemark.geometry.coordinate
            }) {
            self.show(office: office)
        }
        else if let bonus = self.viewModel?
            .bonusService
            .bonuses
            .first(where: {
                $0.coordinate == placemark.geometry.coordinate
                
            }) {
            self.show(bonus: bonus)
        }
        
    }
    
    private func show(office: IOffice) {
        
        let viewModel = BankContentViewModel(office: office)
        let viewController = BankContentViewController()
        viewController.viewModel = viewModel
        viewController.viewModel?.delegate = self
        viewController.addRouteCompletion = { [weak self] office in
            self?.createRoute(toOffice: office)
        }
        viewController.showFreeOffice = { [weak self] freeOffice, vc in
            
            vc.dismiss(animated: true) {
                let cameraPosition = YMKCameraPosition(target: freeOffice.location.point, zoom: 16, azimuth: 0, tilt: 0)
                let animation = YMKAnimation(type: .smooth, duration: 2)
                self?.mapView.mapWindow.map.move(with: cameraPosition, animation: animation, cameraCallback: { _ in
                    self?.show(office: freeOffice)
                })
                
            }
            
        }
        self.present(viewController, animated: true)
        
    }
    
    private func show(bonus: IBonus) {
        
        let bonusViewController = BonusViewController()
        bonusViewController.bonus = bonus
        
        self.present(bonusViewController, animated: true)
        
    }
    
}

extension MapViewController: IBankContentViewControllerDelegate {
    
    var offices: [IOffice] {
        self.viewModel?.officeService.offices ?? []
    }
    
}

extension MapViewController: IRouteLocationDelegate {}

class MapViewController: UIViewController {
    
    var viewModel: IMapViewModel?
    
    private var fpc: FloatingPanelController!
    
    private lazy var scaleMapStackView: MapButtonVerticalStackView = MapButtonVerticalStackView()
    
    private lazy var bottomMapButtonStackView: MapButtonVerticalStackView = MapButtonVerticalStackView()
    
    private lazy var topMapButtonStackView: MapButtonVerticalStackView = MapButtonVerticalStackView()
    
    private let mapView: YMKMapView = YMKMapView()
    
    private var map: YMKMap {
        self.mapView.mapWindow.map
    }
    
    private lazy var mapObjectTapListener: YMKMapObjectTapListener = MapObjectTapListener(controller: self)
    
    private var drivingSession: YMKDrivingSession?
    
    private var routesCollection: YMKMapObjectCollection!
    
    private var bonusesCollection: YMKMapObjectCollection!
    
    private var routes: [YMKDrivingRoute] = [] {
        didSet {
            self.updateRouteButton()
        }
    }
    
    private var showBonuses: Bool = false {
        didSet {
            self.updateBonusLayer()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.setupViewModel()
        self.setupScaleMapStackView()
        self.setupBottomMapButtonStackView()
        self.setupTopMapButtonStackView()
        self.layout()
        self.updateData()
        
        self.routesCollection = map.mapObjects.add()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.viewModel?.locationManager.requestWhenInUseAuthorization()
//        self.viewModel?.requestLocation()
        self.updateRouteButton()
        
        guard let viewModel = self.viewModel else { return }
        
        switch viewModel.locationManager.authorizationStatus {
        case .notDetermined:
            viewModel.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // show message
            break
        case .denied:
            // show message
            break
        case .authorizedWhenInUse, .authorizedAlways:
            viewModel.requestLocation()
        default:
            break
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel?.locationManager.stopUpdatingLocation()
    }

    private func setupViewModel() {
        
        self.viewModel?.driverRouteService.delegate = self
        self.viewModel?.pedastrinaRouteService.delegate = self
        self.viewModel?.bicyсleRouteService.delegate = self
        self.viewModel?.masstransitRouteService.delegate = self
        
        self.routesCollection = map.mapObjects.add()
        self.bonusesCollection = map.mapObjects.add()
        self.viewModel?.createRouteCompletion = { [weak self] result in
            
            switch result {
            case let .failure(error):
                break
            case let .success(office):
                self?.showRoutePanel(office: office)
            }
            
            
        }
        
        self.viewModel?.requestLocationCompletion = { [weak self] location in
            
            self?.currentLocation = location
            self?.updateCurrentLocation(location: location)
            
        }
        
        self.viewModel?.updateDataCompletion = { [weak self] error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self?.layoutPlacemarks()
            
        }
        
    }
    
    private func showRoutePanel(office: IOffice) {
        
        if let prepareRouteViewController = self.fpc?.contentViewController as? PrepareRouteViewController,
           prepareRouteViewController.view.window != nil
        {
            if let activeRouteType = prepareRouteViewController.activeRouteType {
                self.showRoutes(forType: activeRouteType)
            }
            prepareRouteViewController.updateTitle()
        }
        else {
            
            self.fpc = FloatingPanelController()
            
            self.fpc.layout = MyFloatingPanelLayout()
            
            // Set a content view controller.
            let contentVC = PrepareRouteViewController()
            contentVC.office = office
            contentVC.delegate = self
            contentVC.mapViewModel = self.viewModel
            contentVC.closeCompletion = { [weak self] in
                self?.removeRoutes()
                self?.viewModel?.removeRoutes()
            }

            let appearance = SurfaceAppearance()
            appearance.cornerRadius = 16
            fpc.surfaceView.appearance = appearance
            
            self.fpc.set(contentViewController: contentVC)
            
            self.view.addSubview(fpc.view)

            // REQUIRED. It makes the floating panel view have the same size as the controller's view.
            fpc.view.frame = self.view.bounds

            // In addition, Auto Layout constraints are highly recommended.
            // Constraint the fpc.view to all four edges of your controller's view.
            // It makes the layout more robust on trait collection change.
            fpc.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
              fpc.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
              fpc.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0.0),
              fpc.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0.0),
              fpc.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
            ])

            // Add the floating panel controller to the controller hierarchy.
            self.addChild(fpc)

            // Show the floating panel at the initial position defined in your `FloatingPanelLayout` object.
            fpc.show(animated: true) { [weak self] in
                // Inform the floating panel controller that the transition to the controller hierarchy has completed.
                self?.fpc.didMove(toParent: self)
            }
            
        }
        
        
        
    }
    
    private func updateData() {
        
        self.viewModel?.updateData()
        
    }
    
    private func setupScaleMapStackView() {
        
        let scalePlusMapButton = ScalePlusMapButton()
        scalePlusMapButton.action = { [weak self] _ in
            
            self?.map.scaleMap(value: 1)
            
        }
        
        let scaleMinusMapButton = ScaleMinusMapButton()
        scaleMinusMapButton.action = { [weak self] _ in
            
            self?.map.scaleMap(value: -1)
            
        }
        
        self.scaleMapStackView.setButtons(buttons: [scalePlusMapButton, scaleMinusMapButton])
        
    }
    
    private func setupBottomMapButtonStackView() {
        
        let locationMapButton: CurrentLocationMapButton = CurrentLocationMapButton()
        
        locationMapButton.action = { [weak self] _ in
            self?.moveToCurrentLocation()
        }
        
        self.bottomMapButtonStackView.setButtons(buttons: [locationMapButton])
        
    }
    
    private func setupTopMapButtonStackView() {
        
        let bonusMapButton: BonusMapButton = BonusMapButton()
        
        bonusMapButton.action = { [weak self] _ in
            self?.showBonuses.toggle()
        }
        
        self.topMapButtonStackView.setButtons(buttons: [bonusMapButton])
        
    }
    
    private func updateRouteButton() {
        guard let button = self.bottomMapButtonStackView.buttons.first(where: { $0 is RouteMapButton }) else { return }
        button.isHidden = self.routes.isEmpty
    }
    
    private let locationArrowButtonSize: CGFloat = 48
    
    private let locationArrowButtonPadding: CGFloat = 88 + 16
    
    private lazy var currentLocationPlacemark: YMKPlacemarkMapObject = {
        
        let image = UIImage(named: "location")!
        let placemark = map.mapObjects.addPlacemark()
        placemark.setIconWith(image)
            
        return placemark
        
    }()
    
    private(set) var currentLocation: CLLocation? {
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

//MARK: - Routes

extension MapViewController {
    
    private func removeRoutes() {
        self.routes.removeAll()
        self.routesCollection.clear()
    }
    
    private func createRoute(toOffice office: IOffice) {
        
        self.viewModel?.createRoute(toOffice: office)
        
    }
    
}

//MARK: - Cluster

extension MapViewController: YMKClusterListener {
    
    private var FONT_SIZE: CGFloat {
        15
    }
    private var MARGIN_SIZE: CGFloat {
        3
    }
    private var STROKE_SIZE: CGFloat {
        3
    }
    
    private func clusterImage(_ clusterSize: UInt) -> UIImage {
        let scale = UIScreen.main.scale
        let text = (clusterSize as NSNumber).stringValue
        let font = UIFont.systemFont(ofSize: FONT_SIZE * scale)
        let size = text.size(withAttributes: [NSAttributedString.Key.font: font])
        let textRadius = sqrt(size.height * size.height + size.width * size.width) / 2
        let internalRadius = textRadius + MARGIN_SIZE * scale
        let externalRadius = internalRadius + STROKE_SIZE * scale
        let iconSize = CGSize(width: externalRadius * 2, height: externalRadius * 2)

        UIGraphicsBeginImageContext(iconSize)
        let ctx = UIGraphicsGetCurrentContext()!

        ctx.setFillColor(AppColor.primary.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: .zero,
            size: CGSize(width: 2 * externalRadius, height: 2 * externalRadius)));

        ctx.setFillColor(UIColor.white.cgColor)
        ctx.fillEllipse(in: CGRect(
            origin: CGPoint(x: externalRadius - internalRadius, y: externalRadius - internalRadius),
            size: CGSize(width: 2 * internalRadius, height: 2 * internalRadius)));

        (text as NSString).draw(
            in: CGRect(
                origin: CGPoint(x: externalRadius - size.width / 2, y: externalRadius - size.height / 2),
                size: size),
            withAttributes: [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: UIColor.black])
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func onClusterAdded(with cluster: YMKCluster) {
        cluster.appearance.setIconWith(clusterImage(cluster.size))
    }
    
}

//MARK: - Placemark Office

extension MapViewController {
    
    private func layoutPlacemarks() {
        
        guard let viewModel = self.viewModel else { return }
        
        let collectionPlacemarks = mapView.mapWindow.map.mapObjects.addClusterizedPlacemarkCollection(with: self)
        
        for office in viewModel.officeService.offices {
            
            self.addPlacemarkOffice(office: office, toCollection: collectionPlacemarks)
            
        }
        
        collectionPlacemarks.clusterPlacemarks(withClusterRadius: 60, minZoom: 15)
        
    }
    
    private func addPlacemarkOffice(office: IOffice, toCollection collection: YMKClusterizedPlacemarkCollection) {
        
        let image = office.iconImage!
        
        let placemark = collection.addPlacemark()
        placemark.geometry = office.coordinate.point
        let style = YMKIconStyle(anchor: nil, rotationType: nil, zIndex: nil, flat: nil, visible: nil, scale: 1.5, tappableArea: nil)
        placemark.setIconWith(image, style: style)
        placemark.isDraggable = true

        placemark.addTapListener(with: mapObjectTapListener)
        
    }
    
    private func addPlacemarkBonus(bonus: IBonus) {
        
        let image = UIImage(named: "bonus")!
        
        let placemark = self.bonusesCollection.addPlacemark()
        placemark.geometry = bonus.coordinate.point
        let style = YMKIconStyle(anchor: nil, rotationType: nil, zIndex: nil, flat: nil, visible: nil, scale: 1, tappableArea: nil)
        placemark.setIconWith(image, style: style)
        placemark.isDraggable = true
        
        placemark.addTapListener(with: mapObjectTapListener)

    }
    
    private func updateBonusLayer() {
        
        guard showBonuses else {
            self.bonusesCollection.clear()
            return
        }
        
        guard let viewModel = self.viewModel else { return }
        
        for bonus in viewModel.bonusService.bonuses {
            
            self.addPlacemarkBonus(bonus: bonus)
            
        }
        
    }
    
}

//MARK: - PrepareRouteViewControllerDelegate

extension MapViewController: PrepareRouteViewControllerDelegate {
    
    func showRoutes(forType type: PrepareRouteViewController.RouteType) {
        
        self.removeRoutes()
        
        switch type {
            
        case .drive:
            
            guard let routes = self.viewModel?.driverRouteService.routes else { return }
            
            routes.enumerated().forEach { pair in
            
                let routePolyline = self.routesCollection.addPolyline(with: pair.element.geometry)
                
                if pair.offset == 0 {
                    routePolyline.styleMainRoute()
                } else {
                    routePolyline.styleAlternativeRoute()
                }
                
            }
            
        case .pedastrian:
            
            guard let route = self.viewModel?.pedastrinaRouteService.routes.first else { return }
            
            let routePolyline = self.routesCollection.addPolyline(with: route.geometry)
            
            routePolyline.stylePedastrianRoute()
            
        case .bicycle:
            
            guard let route = self.viewModel?.bicyсleRouteService.routes.first else { return }
            
            let routePolyline = self.routesCollection.addPolyline(with: route.geometry)
            
            routePolyline.styleBicycelRoute()
            
        case .masstransit:
            
            guard let route = self.viewModel?.masstransitRouteService.routes.last else { return }
            
            let routePolyline = self.routesCollection.addPolyline(with: route.geometry)
            
            routePolyline.styleMasstransitRoute()
            
        }
    }
    
}

//MARK: - Layout

extension MapViewController {
    
    private func layout() {
        
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.scaleMapStackView.translatesAutoresizingMaskIntoConstraints = false
        self.bottomMapButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        self.topMapButtonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        for button in self.scaleMapStackView.buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        
        for button in self.bottomMapButtonStackView.buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        
        for button in self.topMapButtonStackView.buttons {
            button.translatesAutoresizingMaskIntoConstraints = false
        }
        
        self.view.addSubview(self.mapView)
        self.view.addSubview(self.scaleMapStackView)
        self.view.addSubview(self.bottomMapButtonStackView)
        self.view.addSubview(self.topMapButtonStackView)

        self.mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.mapView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        self.mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true

        self.scaleMapStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.scaleMapStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        
        for button in self.scaleMapStackView.buttons {
            button.widthAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
            button.layer.cornerRadius = locationArrowButtonSize / 2
            button.clipsToBounds = true
        }
        
        self.bottomMapButtonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.bottomMapButtonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        for button in self.bottomMapButtonStackView.buttons {
            button.widthAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
            button.layer.cornerRadius = locationArrowButtonSize / 2
            button.clipsToBounds = true
        }
        
        self.topMapButtonStackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16).isActive = true
        self.topMapButtonStackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        
        for button in self.topMapButtonStackView.buttons {
            button.widthAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
            button.heightAnchor.constraint(equalToConstant: locationArrowButtonSize).isActive = true
            button.layer.cornerRadius = locationArrowButtonSize / 2
            button.clipsToBounds = true
        }
        
    }
    
}
