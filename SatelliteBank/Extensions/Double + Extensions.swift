//
//  Double + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import Foundation

extension Double {
    
    var timeToFinishDescription: String {
        
        let value = Int(self)
        
        let hours = value / 3600
        
        let minutes = (value % 3600) / 60
        
        let hoursText = hours > 0 ? "\(hours) ч" : ""
        
        let minutesText = minutes > 0 ? "\(minutes) мин" : ""
        
        let text = "\(hoursText) \(minutesText)".trim()
        
        return text
        
    }
    
}
