//
//  PrimaryButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

class PrimaryButton: UIButton {
    
    var action: ((PrimaryButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.backgroundColor = AppColor.primary
        self.setTitleColor(.white, for: .normal)
        self.addTarget(self, action: #selector(self.tapAction), for: .touchUpInside)
    }
    
    @objc
    func tapAction() {
        self.action?(self)
    }
}
