//
//  LocationArrowButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LocationArrowButton: UIButton {
    
    var action: ((LocationArrowButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        let image = UIImage(named: "location_arrow")
        self.setImage(image, for: .normal)
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
    
    @objc
    func tapAction(_ sender: LocationArrowButton) {
        self.action?(sender)
    }
}

