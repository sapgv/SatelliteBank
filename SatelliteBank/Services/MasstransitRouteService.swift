//
//  MasstransitRouteService.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import YandexMapsMobile
import CoreLocation

final class MasstransitRouteService {
    
    private(set) var routes: [YMKMasstransitRoute] = []
    
    private(set) var summary: YMKMasstransitSummary?
    
    weak var delegate: IRouteLocationDelegate?
    
    private(set) var drivingSession: YMKMasstransitSession?
    
    private(set) var summarySession: YMKMasstransitSummarySession?
    
    private(set) var timeOptions: YMKTimeOptions
    
    init(timeOptions: YMKTimeOptions = MasstransitRouteService.createTimeOption()) {
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

extension MasstransitRouteService {
    
    static func createTimeOption() -> YMKTimeOptions {
        let timeOptions = YMKTimeOptions()
        return timeOptions
    }
    
}

//MARK: - Request Points

extension MasstransitRouteService {
    
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

extension MasstransitRouteService {
    
    func createSummary(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKTransport.sharedInstance().createMasstransitRouter()
        
        let transitOptions = YMKTransitOptions()
        
        self.summarySession = drivingRouter.requestRoutesSummary(with: requestPoints, transitOptions: transitOptions) { summary, error in
            
            if let summary = summary?.first {
                self.summary = summary
                completion(nil)
            }
            else {
                completion(error!.NSError)
            }
            
        }
            
    }
    
}

//MARK: - Routes

extension MasstransitRouteService {
    
    func createRoutePrivate(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKTransport.sharedInstance().createMasstransitRouter()
        
        let transitOptions = YMKTransitOptions()
        
        self.drivingSession = drivingRouter.requestRoutes(with: requestPoints, transitOptions: transitOptions) { routes, error in
            
            if let routes = routes {
                
                self.routes = routes
                
                completion(nil)
                
            }
            else {
                completion(error!.NSError)
            }
            
        }
        
    }
    
}
