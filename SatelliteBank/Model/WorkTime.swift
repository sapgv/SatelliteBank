//
//  WorkTime.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import Foundation

protocol IWorkTime: AnyObject {
    
    var days: String { get }
    
    var hours: String { get }
    
}

final class WorkTime: IWorkTime {
    
    let days: String
    
    let hours: String
    
    init(data: [String: Any]) {
        self.days = data["days"] as? String ?? ""
        self.hours = data["hours"] as? String ?? ""
    }
    
}
