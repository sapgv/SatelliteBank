//
//  DriverRouteService.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import YandexMapsMobile
import CoreLocation

final class DriverRouteService {
    
    private(set) var routes: [YMKDrivingRoute] = []
    
    var routesCollection: YMKMapObjectCollection!
    
    weak var delegate: IRouteLocationDelegate?
    
    var drivingSession: YMKDrivingSession?
    
    func removeRoutes() {
        self.drivingSession?.cancel()
        self.routes.removeAll()
        self.routesCollection.clear()
    }
    
    func createRoute(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let currentLocation = delegate?.currentLocation else { return }
        
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
                self.onRoutesReceived(routes, completion: completion)
            } else {
                self.onRoutesError(error!, completion: completion)
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
    
    private func onRoutesReceived(_ routes: [YMKDrivingRoute], completion: @escaping (NSError?) -> Void) {
        
        self.removeRoutes()
        
        self.routes = routes
        
        routes.enumerated().forEach { pair in
            let routePolyline = self.routesCollection.addPolyline(with: pair.element.geometry)
            if pair.offset == 0 {
                routePolyline.styleMainRoute()
            } else {
                routePolyline.styleAlternativeRoute()
            }
        }
        
        completion(nil)
        
    }
    
    private func onRoutesError(_ error: Error, completion: @escaping (NSError?) -> Void) {
        
        completion(error.NSError)
        
    }
    
}
