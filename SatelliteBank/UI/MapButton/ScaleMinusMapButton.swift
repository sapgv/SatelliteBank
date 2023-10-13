//
//  ScaleMinusMapButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class ScaleMinusMapButton: MapButton {
    
    override func commonInit() {
        super.commonInit()
        let image = UIImage(systemName: "minus")
        self.setImage(image, for: .normal)
    }
    
}
