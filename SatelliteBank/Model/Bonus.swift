//
//  Bonus.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import CoreLocation

protocol IBonus: AnyObject {
    
    var name: String { get }
    
    var address: String { get }
    
    var coordinate: CLLocationCoordinate2D { get }
    
    var percent: Double { get }
    
}

final class Bonus: IBonus {
    
    let name: String
    
    let address: String
    
    let coordinate: CLLocationCoordinate2D
    
    let percent: Double
    
    init(data: [String: Any]) {
        self.name = data["name"] as? String ?? ""
        self.address = data["address"] as? String ?? ""
        let percentString = data["percent"] as? String ?? ""
        self.percent = Double(percentString) ?? 0
        let latitude = data["lat"] as? Double ?? 0
        let longitude = data["lng"] as? Double ?? 0
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
