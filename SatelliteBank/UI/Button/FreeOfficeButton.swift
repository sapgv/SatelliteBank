//
//  FreeOfficeButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 15.10.2023.
//

import UIKit

final class FreeOfficeButton: PrimaryInvertedButton {
    
    var action: ((FreeOfficeButton) -> Void)?
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + 16, height: size.height)
    }
    
    override func commonInit() {
        super.commonInit()
        self.addTarget(self, action: #selector(self.tapAction), for: .touchUpInside)
    }
    
    @objc
    func tapAction() {
        self.action?(self)
    }
    
}
