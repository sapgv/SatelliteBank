//
//  UITableView + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

extension UITableView {
    
    static func restoreAppearance() {
        if #available(iOS 15.0, *) {
            UITableView.appearance().sectionHeaderTopPadding = 0.0
        }
    }
    
    
}
