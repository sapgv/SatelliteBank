//
//  CloseButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class CloseButton: UIButton {
    
    var action: ((CloseButton) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        let image = UIImage(systemName: "xmark.circle.fill")!
        self.setImage(image, for: .normal)
        self.tintColor = .lightGray
        self.addTarget(self, action: #selector(self.tapAction), for: .touchUpInside)
    }
    
    @objc
    func tapAction() {
        self.action?(self)
    }
    
}
