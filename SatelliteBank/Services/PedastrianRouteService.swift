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
    
    private(set) var summary: YMKMasstransitSummary?
    
    weak var delegate: IRouteLocationDelegate?
    
    private var drivingSession: YMKMasstransitSession?
    
    private var summarySession: YMKMasstransitSummarySession?
    
    private var timeOptions: YMKTimeOptions
    
    init(timeOptions: YMKTimeOptions = PedastrianRouteService.createTimeOption()) {
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

extension PedastrianRouteService {
    
    static func createTimeOption() -> YMKTimeOptions {
        let timeOptions = YMKTimeOptions()
        return timeOptions
    }
    
}

//MARK: - Request Points

extension PedastrianRouteService {
    
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

extension PedastrianRouteService {
    
    private func createSummary(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKTransport.sharedInstance().createPedestrianRouter()
        
        self.summarySession = drivingRouter.requestRoutesSummary(with: requestPoints, timeOptions: timeOptions) { summary, error in
            
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

extension PedastrianRouteService {
    
    private func createRoutePrivate(toOffice office: IOffice, completion: @escaping (NSError?) -> Void) {
        
        guard let requestPoints = self.requestPoints(toOffice: office) else {
            completion(RouteError.createRouteFailure.NSError)
            return
        }
        
        let drivingRouter = YMKTransport.sharedInstance().createPedestrianRouter()
        
        self.drivingSession = drivingRouter.requestRoutes(with: requestPoints, timeOptions: timeOptions) { routes, error in
            
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
