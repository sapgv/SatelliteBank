//
//  RouteLocationDelegate.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit
import CoreLocation

protocol IRouteLocationDelegate: UIViewController {
    
    var currentLocation: CLLocation? { get }
    
}
