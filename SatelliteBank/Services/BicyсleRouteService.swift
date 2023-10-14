//
//  BicyсleRouteService.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import YandexMapsMobile
import CoreLocation

final class BicyсleRouteService {
    
    private(set) var routes: [YMKBicycleRoute] = []
    
    private(set) var summary: YMKBicycleSummary?
    
    weak var delegate: IRouteLocationDelegate?
    
    private(set) var drivingSession: YMKBicycleSession?
    
    private(set) var summarySession: YMKBicycleSummarySession?
    
    private(set) var timeOptions: YMKTimeOptions
    
    init(timeOptions: YMKTimeOptions = BicyсleRouteService.createTimeOption()) {
        self.timeOptions = timeOptions
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

//MARK: - Options

extension BicyсleRouteService {
    
    static func createTimeOption() -> YMKTimeOptions {
        let timeOptions = YMKTimeOptions()
        return timeOptions
    }
    
}

//MARK: - Request Points

extension BicyсleRouteService {
    
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

extension BicyсleRouteService {
    
    func createSummary(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKTransport.sharedInstance().createBicycleRouter()
        
        self.summarySession = drivingRouter.requestRoutesSummary(with: requestPoints, type: .bicycle) { [weak self] summary, error in
            
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

extension BicyсleRouteService {
    
    func createRoutePrivate(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKTransport.sharedInstance().createBicycleRouter()
        
        self.drivingSession = drivingRouter.requestRoutes(with: requestPoints, type: .bicycle) { [weak self] routes, error in
            
            guard let routes = routes else {
                completion(error?.NSError)
                return
            }
            
            self?.routes = routes
            completion(nil)
            
        }
            
    }
    
}
