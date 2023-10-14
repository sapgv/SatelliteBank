//
//  PedastrianRouteService.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import YandexMapsMobile
import CoreLocation

final class PedastrianRouteService {
    
    private(set) var routes: [YMKMasstransitRoute] = []
    
    var routesCollection: YMKMapObjectCollection!
    
    weak var delegate: IRouteLocationDelegate?
    
    var drivingSession: YMKMasstransitSession?
    
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
        
        let responseHandler = { (routesResponse: [YMKMasstransitRoute]?,
                                 error: Error?) -> Void in
            if let routes = routesResponse {
                self.onRoutesReceived(routes, completion: completion)
            } else {
                self.onRoutesError(error!, completion: completion)
            }
        }
        
        let drivingRouter = YMKPedestrianRouter()
        
        let timeOpetions = YMKTimeOptions()
        
        drivingSession = drivingRouter.requestRoutes(with: requestPoints, timeOptions: timeOpetions, routeHandler: responseHandler)
        
    }
    
    private func onRoutesReceived(_ routes: [YMKMasstransitRoute], completion: @escaping (NSError?) -> Void) {
        
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
