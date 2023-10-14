//
//  ScheduleRouteButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

class ScheduleRouteButton: UIButton {
    
    var action: ((MapButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc
    func tapAction(_ sender: MapButton) {
        self.action?(sender)
    }
    
}
