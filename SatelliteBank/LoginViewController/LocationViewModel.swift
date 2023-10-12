//
//  LocationViewModel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 11.10.2023.
//

import Foundation
import CoreLocation

protocol ILocationViewModel: NSObject {
    
    var locationManager: CLLocationManager { get }
    
    var requestLocationCompletion: ((CLLocation) -> Void)? { get set }
    
    func requestLocation()
    
    
    
}

final class LocationViewModel: NSObject, ILocationViewModel {
    
    let locationManager: CLLocationManager
    
    var requestLocationCompletion: ((CLLocation) -> Void)?
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestLocation() {
        self.locationManager.startUpdatingLocation()
    }
    
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        
        guard let location = locations.first else { return }
        self.requestLocationCompletion?(location)

    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("LOG didFailWithError \(error.localizedDescription)")
        // Handle failure to get a user’s location
    }
}
