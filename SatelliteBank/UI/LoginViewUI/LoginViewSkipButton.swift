//
//  LoginViewSkipButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LoginViewSkipButton: SecondaryButton {
    
    override func commonInit() {
        super.commonInit()
        self.setTitle("Пропустить", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
}
