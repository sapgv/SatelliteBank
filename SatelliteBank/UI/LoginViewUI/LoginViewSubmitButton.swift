//
//  LoginViewSubmitButton.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LoginViewSubmitButton: PrimaryButton {
    
    override func commonInit() {
        super.commonInit()
        self.setTitle("Получить код", for: .normal)
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
}
