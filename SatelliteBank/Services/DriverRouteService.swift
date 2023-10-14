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
    
    private(set) var summary: YMKDrivingSummary?
    
    weak var delegate: IRouteLocationDelegate?
    
    private(set) var drivingSession: YMKDrivingSession?
    
    private(set) var summarySession: YMKDrivingSummarySession?
    
    private(set) var drivingOptions: YMKDrivingDrivingOptions
    
    private(set) var vehicleOptions: YMKDrivingVehicleOptions
    
    init(drivingOptions: YMKDrivingDrivingOptions = DriverRouteService.createDrivingOption(),
         vehicleOptions: YMKDrivingVehicleOptions = DriverRouteService.createVehicleOptions()) {
        self.drivingOptions = drivingOptions
        self.vehicleOptions = vehicleOptions
    }
    
    func removeRoutes() {
        self.drivingSession?.cancel()
        self.summarySession?.cancel()
        self.routes.removeAll()
        self.summary = nil
    }
    
    func createRoute(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {

        let group = DispatchGroup()

        var resultError: NSError?
        
        let resultQueue = DispatchQueue(label: "DriverRouteServiceQueue", attributes: .concurrent)
        
        group.enter()
        
        self.createRoutePrivate(toOffice: office) { error in
            
            resultQueue.async(flags: .barrier) {

                defer {
                    group.leave()
                }
                
                resultError = error
                
                
                
            }
            
        }
        
        group.enter()
        
        self.createSummary(toOffice: office) { error in

            resultQueue.async(flags: .barrier) {

                defer {
                    group.leave()
                }
                
                resultError = error
                
                
                
            }
            
        }
        
        group.notify(queue: .main) {
            
            completion(resultError)
            
        }
        
    }
    
}

//MARK: - Errors

enum RouteError: Error, LocalizedError {
    
    case createRouteFailure
    
    var errorDescription: String? {
        switch self {
        case .createRouteFailure:
            return "Не удалось псотроить маршрут"
        }
    }
}

//MARK: - Request Points

extension DriverRouteService {
    
    private func requestPoints(toOffice office: IOffice) -> [YMKRequestPoint]? {
        
        guard let currentLocation = delegate?.currentLocation else { return nil }
        
        let requestPoints : [YMKRequestPoint] = [
            YMKRequestPoint(
                point: currentLocation.point, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            YMKRequestPoint(
                point: office.coordinate.point, type: .waypoint,
                pointContext: nil, drivingArrivalPointId: nil),
            ]
        
        return requestPoints
        
    }
    
}

//MARK: - Summary

extension DriverRouteService {
    
    private func createSummary(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        
        self.summarySession = drivingRouter.requestRoutesSummary(with: requestPoints, drivingOptions: drivingOptions, vehicleOptions: vehicleOptions) { [weak self] summary, error in
            
            guard let summary = summary?.first else {
                completion(error?.NSError)
                return
            }
            
            self?.summary = summary
            completion(nil)
            
        }
        
    }
    
}

//MARK: - Routes

extension DriverRouteService {
    
    private func createRoutePrivate(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        
        self.drivingSession = drivingRouter.requestRoutes(with: requestPoints, drivingOptions: drivingOptions, vehicleOptions: YMKDrivingVehicleOptions()) { [weak self] routes, error in
            
            guard let routes = routes else {
                completion(error?.NSError)
                return
            }
            
            self?.routes = routes
            completion(nil)
            
        }
        
    }
    
}

//MARK: - Options

extension DriverRouteService {
    
    static func createDrivingOption() -> YMKDrivingDrivingOptions {
        let drivingOptions = YMKDrivingDrivingOptions()
        drivingOptions.routesCount = 2
        return drivingOptions
    }
    
    static func createVehicleOptions() -> YMKDrivingVehicleOptions {
        let vehicleOptions = YMKDrivingVehicleOptions()
        return vehicleOptions
    }
    
}
