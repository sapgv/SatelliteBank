//
//  OfficeLoad.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

enum OfficeLoad: String {
    
    case low = "Нет очереди"
    case medium = "Средняя загруженность"
    case high = "Нужно подождать"
    
    var title: String {
        self.rawValue
    }
    
    var waitTitle: String {
        switch self {
        case .low:
            return "Время ожидания 0 мин"
        case .medium:
            return "Время ожидания 15 мин"
        case .high:
            return "Время ожидания 30 мин"
        }
    }
    
    var color: UIColor {
        switch self {
        case .low:
            return .systemGreen
        case .medium:
            return .systemOrange
        case .high:
            return .systemRed
        }
    }
    
}
