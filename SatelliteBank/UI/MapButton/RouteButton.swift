//
//  RouteButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

final class RouteButton: MapButton {
    
    override func commonInit() {
        super.commonInit()
        let image = UIImage(systemName: "arrow.triangle.swap")
        self.setImage(image, for: .normal)
    }
    
}
