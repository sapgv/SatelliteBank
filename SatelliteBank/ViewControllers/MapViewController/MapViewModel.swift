//
//  MapViewModel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 11.10.2023.
//

import Foundation
import CoreLocation

protocol IMapViewModel: NSObject {
    
    var officeService: IOfficeService { get }
    
    var locationManager: CLLocationManager { get }
    
    var requestLocationCompletion: ((CLLocation) -> Void)? { get set }
    
    var createRouteCompletion: ((Swift.Result<IOffice, NSError>) -> Void)? { get set }
    
    var driverRouteService: DriverRouteService { get }
    
    func requestLocation()
    
    func createRoute(toOffice office: IOffice)
    
    func clearRoutes()
    
}

final class MapViewModel: NSObject, IMapViewModel {
    
    let officeService: IOfficeService
    
    let locationManager: CLLocationManager
    
    var requestLocationCompletion: ((CLLocation) -> Void)?
    
    var createRouteCompletion: ((Swift.Result<IOffice, NSError>) -> Void)?
    
    var driverRouteService: DriverRouteService
    
    var pedastrinaRouteService: PedastrianRouteService
    
    init(officeService: IOfficeService = OfficeService.shared,
         locationManager: CLLocationManager = CLLocationManager(),
         driverRouteService: DriverRouteService = DriverRouteService(),
         pedastrinaRouteService: PedastrianRouteService = PedastrianRouteService()) {
        self.officeService = officeService
        self.locationManager = locationManager
        self.driverRouteService = driverRouteService
        self.pedastrinaRouteService = pedastrinaRouteService
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
    func createRoute(toOffice office: IOffice) {
        
        self.driverRouteService.createRoute(toOffice: office) { [weak self] error in
            
            if let error = error {
                self?.createRouteCompletion?(.failure(error.NSError))
            }
            else {
                self?.createRouteCompletion?(.success(office))
            }
            
        }
        
    }
    
    func clearRoutes() {
        
        self.driverRouteService.removeRoutes()
        
    }
    
}

extension MapViewModel: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        guard let location = locations.first else { return }
        self.requestLocationCompletion?(location)

        print("LOG didUpdateLocations \(location)")
        
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("LOG didFailWithError \(error.localizedDescription)")
        // Handle failure to get a user’s location
    }
}
