//
//  ScheduleBycicleRouteButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

final class ScheduleBycicleRouteButton: ScheduleRouteButton {
    
    override func commonInit() {
        super.commonInit()
        let image = UIImage(systemName: "bicycle")
        self.setImage(image, for: .normal)
    }
    
}
