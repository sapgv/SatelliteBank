//
//  YandexMapKit + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import CoreLocation
import YandexMapsMobile


extension CLLocation {
    
    var point: YMKPoint {
        return YMKPoint(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
    }
    
}

extension CLLocationCoordinate2D: Equatable {
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }

    var point: YMKPoint {
        return YMKPoint(latitude: self.latitude, longitude: self.longitude)
    }
    
}

extension YMKPoint {
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
    
}

extension YMKMap {
    
    func scaleMap(value: Float) {
        
        self.move(
            with: YMKCameraPosition(
                target: self.cameraPosition.target,
                zoom: self.cameraPosition.zoom + value,
                azimuth: self.cameraPosition.azimuth,
                tilt: self.cameraPosition.tilt
            ),
            animation: YMKAnimation(type: .linear, duration: 0.3)
            
        )
        
    }
    
}

extension YMKPolylineMapObject {
    func styleMainRoute() {
        zIndex = 10.0
        setStrokeColorWith(.systemGreen)
        strokeWidth = 5.0
        outlineColor = .black
        outlineWidth = 1.0
    }

    func styleAlternativeRoute() {
        zIndex = 5.0
        setStrokeColorWith(.systemYellow)
        strokeWidth = 4.0
        outlineColor = .black
        outlineWidth = 1.0
    }
    
    func stylePedastrianRoute() {
        zIndex = 5.0
        setStrokeColorWith(.systemPurple)
        strokeWidth = 4.0
        outlineColor = .black
        outlineWidth = 1.0
    }
}

extension YMKDrivingRoute {
    
    var distanceToFinish: Double? {
        
        self.routePosition.distanceToFinish()
        
//        guard !self.metadata.routePoints.isEmpty else { return nil }
//
//        let polylineIndex = YMKPolylineUtils.createPolylineIndex(with: self.geometry)
//
//        guard let firstPosition = polylineIndex.closestPolylinePosition(
//            with: self.routePosition.point,
//            priority: .closestToRawPoint,
//            maxLocationBias: 100
//        ) else { return nil }
//
//        guard let secondPosition = polylineIndex.closestPolylinePosition(
//            with: self.metadata.routePoints.last!.position,
//            priority: .closestToRawPoint,
//            maxLocationBias: 100
//        ) else { return nil }
//
//        let distance = Double(
//            YMKPolylineUtils.distanceBetweenPolylinePositions(
//                with: self.geometry,
//                from: firstPosition,
//                to: secondPosition
//            )
//        )
//
//        return distance
        
    }
    
    var timeTravelToPoint: Double? {
        
        self.routePosition.timeToFinish()
        
//        guard let distance = self.distanceToFinish else { return nil }
//
//        let currentPosition = self.routePosition
//        let targetPosition = currentPosition.advance(withDistance: distance)
//        let time = targetPosition.timeToFinish() - currentPosition.timeToFinish()
//        return time
        
    }
    
//    func timeTravelToPoint(route: YMKDrivingRoute, point: YMKPoint) -> Double {
//        let currentPosition = route.routePosition
//        let distance = distanceBetweenPointsOnRoute(
//            route: route,
//            first: currentPosition.point,
//            second: point
//        )
//        let targetPosition = currentPosition.advance(withDistance: distance)
//        return targetPosition.timeToFinish() - currentPosition.timeToFinish()
//    }
    
}
