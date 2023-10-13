//
//  CurrentLocationMapButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class CurrentLocationMapButton: MapButton {
    
    override func commonInit() {
        super.commonInit()
        let image = UIImage(systemName: "location.fill")
        self.setImage(image, for: .normal)
    }
    
}

