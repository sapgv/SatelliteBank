//
//  ScheduleWalkRouteButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

final class ScheduleWalkRouteButton: ScheduleRouteButton {
 
    override func commonInit() {
        super.commonInit()
        let image = UIImage(systemName: "figure.walk")
        self.setImage(image, for: .normal)
    }
    
}
