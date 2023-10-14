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
    
    var pedastrinaRouteService: PedastrianRouteService { get }
    
    func requestLocation()
    
    func createRoute(toOffice office: IOffice)
    
    func removeRoutes()
    
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
        
        var resultError: NSError?
        
        let resultQueue = DispatchQueue(label: "MapViewModelRouteQueue", attributes: .concurrent)
        
        let group = DispatchGroup()
        
        group.enter()
        
        self.driverRouteService.createRoute(toOffice: office) { error in

            resultQueue.async(flags: .barrier) {
                
                defer {
                    group.leave()
                }
                
                resultError = error
            }
            

        }
        
        group.enter()
        
        self.pedastrinaRouteService.createRoute(toOffice: office) { error in

            resultQueue.async(flags: .barrier) {
                
                defer {
                    group.leave()
                }
                
                resultError = error
            }

        }
        
        group.notify(queue: .main) { [weak self] in
            
            if let resultError = resultError {
                self?.createRouteCompletion?(.failure(resultError.NSError))
            }
            else {
                self?.createRouteCompletion?(.success(office))
            }
            
        }
        
    }
    
    func removeRoutes() {
        
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
