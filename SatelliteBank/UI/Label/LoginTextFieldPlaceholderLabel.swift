//
//  LoginTextFieldPlaceholderLabel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

class LoginTextFieldPlaceholderLabel: PrimaryLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commentInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commentInit()
    }
    
    override func commentInit() {
        super.commentInit()
        self.font = UIFont.systemFont(ofSize: 12, weight: .bold)
    }
    
    
}
