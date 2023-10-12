//
//  LoginViewAlternativeLoginButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LoginViewAlternativeLoginButton: SecondaryButton {
    
    override func commonInit() {
        super.commonInit()
        self.setTitle("Войти по карте или логину", for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
    
}
