//
//  BonusMapButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

final class BonusMapButton: MapButton {
    
    override func commonInit() {
        super.commonInit()
        let image = UIImage(named: "bonus")
        self.setImage(image, for: .normal)
    }
    
    
}
