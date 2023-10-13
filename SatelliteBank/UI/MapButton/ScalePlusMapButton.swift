//
//  ScalePlusMapButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class ScalePlusMapButton: MapButton {
    
    override func commonInit() {
        super.commonInit()
        let image = UIImage(systemName: "plus")
        self.setImage(image, for: .normal)
    }
    
}
