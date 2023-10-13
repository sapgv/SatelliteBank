//
//  MapButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

class MapButton: UIButton {
    
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
        self.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.9)
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc
    func tapAction(_ sender: MapButton) {
        self.action?(sender)
    }
    
}
