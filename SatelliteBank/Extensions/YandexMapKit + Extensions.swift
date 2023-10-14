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
    
    func styleBicycelRoute() {
        zIndex = 5.0
        setStrokeColorWith(.systemBlue)
        strokeWidth = 4.0
        outlineColor = .black
        outlineWidth = 1.0
    }
    
    func styleMasstransitRoute() {
        zIndex = 5.0
        setStrokeColorWith(.systemRed)
        strokeWidth = 4.0
        outlineColor = .black
        outlineWidth = 1.0
    }
}

extension YMKDrivingRoute {
    
}
