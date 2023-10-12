//
//  LoginViewMessageLabel.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LoginViewMessageLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.text = "На этот номер придет СМС с кодом подтверждения"
        self.font = UIFont.systemFont(ofSize: 14)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.lineBreakMode = .byWordWrapping
    }
    
}
