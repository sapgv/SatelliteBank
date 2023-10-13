//
//  PrimaryInvertedButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

class PrimaryInvertedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = .systemBackground
        self.setTitleColor(AppColor.primary, for: .normal)
        self.layer.borderColor = AppColor.primary.cgColor
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
    }
    
}
