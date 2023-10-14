//
//  Office.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import CoreLocation
import UIKit

protocol IOffice: AnyObject {
    
    var salePointName: String { get }
    
    var address: String { get }
    
    var status: String { get }
    
    var openHours: [IWorkTime] { get }
    
    var coordinate: CLLocationCoordinate2D { get }
    
    var queue: Int { get }
    
    var load: OfficeLoad { get }
    
    var iconImage: UIImage? { get }
    
    var windows: Int { get }
    
}

extension IOffice {
    
    var load: OfficeLoad {
        switch self.queue {
        case 0...5:
            return .low
        case 6...15:
            return .medium
        default:
            return .high
        }
    }
    
    var iconImage: UIImage? {
        switch self.load {
        case .low:
            return UIImage(named: "icon_green")
        case .medium:
            return UIImage(named: "icon_yellow")
        case .high:
            return UIImage(named: "icon_red")
        }
        
    }
    
}

final class Office: IOffice {
    
    let salePointName: String
    
    let address: String
    
    let status: String
    
    let openHours: [IWorkTime]
    
    let coordinate: CLLocationCoordinate2D

    let queue: Int
    
    let windows: Int
    
    init(data: [String: Any]) {
        self.salePointName = data["salePointName"] as? String ?? ""
        self.address = data["address"] as? String ?? ""
        self.status = data["status"] as? String ?? ""
        
        let openHoursArray = data["openHours"] as? [[String: Any]] ?? []
        self.openHours = openHoursArray.map { WorkTime(data: $0) }
        
        let latitude = data["latitude"] as? CGFloat ?? 0
        let longitude = data["longitude"] as? CGFloat ?? 0
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.queue = Int.random(in: 1...30)
        self.windows = Int.random(in: 1...15)
        
    }
    
}
