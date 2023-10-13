//
//  Office.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import CoreLocation

protocol IOffice: AnyObject {
    
    var salePointName: String { get }
    
    var address: String { get }
    
    var status: String { get }
    
    var openHours: [IWorkTime] { get }
    
    var coordinate: CLLocationCoordinate2D { get }
    
}

final class Office: IOffice {
    
    let salePointName: String
    
    let address: String
    
    let status: String
    
    let openHours: [IWorkTime]
    
    let coordinate: CLLocationCoordinate2D

    internal init(salePointName: String, address: String, status: String = "", openHours: [IWorkTime] = [], coordinate: CLLocationCoordinate2D) {
        self.salePointName = salePointName
        self.address = address
        self.status = status
        self.openHours = openHours
        self.coordinate = coordinate
    }
    
    init(data: [String: Any]) {
        self.salePointName = data["salePointName"] as? String ?? ""
        self.address = data["address"] as? String ?? ""
        self.status = data["status"] as? String ?? ""
        
        let openHoursArray = data["openHours"] as? [[String: Any]] ?? []
        self.openHours = openHoursArray.map { WorkTime(data: $0) }
        
        let latitude = data["latitude"] as? CGFloat ?? 0
        let longitude = data["longitude"] as? CGFloat ?? 0
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
