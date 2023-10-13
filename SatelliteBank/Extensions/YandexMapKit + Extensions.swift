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
