//
//  PrimaryLabel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

class PrimaryLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commentInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commentInit()
    }
    
    func commentInit() {
        self.textColor = AppColor.primary
    }
    
}
