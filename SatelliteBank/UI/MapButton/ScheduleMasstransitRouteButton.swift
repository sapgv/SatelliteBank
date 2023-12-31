//
//  ScheduleMasstransitRouteButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

final class ScheduleMasstransitRouteButton: ScheduleRouteButton {
 
    override func commonInit() {
        super.commonInit()
        let image = UIImage(systemName: "bus.fill")
        self.setImage(image, for: .normal)
    }
    
}
