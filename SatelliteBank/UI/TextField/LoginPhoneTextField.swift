//
//  LoginPhoneTextField.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LoginPhoneTextField: UITextField {
    
    var editingChangedAction: ((LoginPhoneTextField) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.placeholder = "Номер телефона"
        self.keyboardType = .numberPad
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.isSecureTextEntry = false
        self.addTarget(self, action: #selector(self.editingChanged), for: .editingChanged)
    }
    
    @objc
    func editingChanged(_ sender: LoginPhoneTextField) {
        
        defer {
            self.editingChangedAction?(sender)
        }
        
        let text = (sender.text ?? "").trim()
        if text == "+" {
            sender.text = ""
        }
        else {
            sender.text = sender.text?.phoneRu()
        }
    }
    
}


