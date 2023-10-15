//
//  ScheduleButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class ScheduleButton: PrimaryInvertedButton {

    var action: ((ScheduleButton) -> Void)?
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 16, height: size.height)
    }
    
    override func commonInit() {
        super.commonInit()
        self.setTitle("Запланировать посещение", for: .normal)
        self.addTarget(self, action: #selector(self.tapAction), for: .touchUpInside)
    }
    
    @objc
    func tapAction() {
        self.action?(self)
    }
    
}


