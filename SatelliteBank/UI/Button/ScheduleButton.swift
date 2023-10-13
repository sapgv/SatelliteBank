//
//  ScheduleButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class ScheduleButton: PrimaryInvertedButton {

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 16, height: size.height)
    }
    
}


