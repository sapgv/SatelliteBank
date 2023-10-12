//
//  LoginViewLogoImageView.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LoginViewLogoImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.image = UIImage(named: "vtb_online_logo")
        self.contentMode = .scaleAspectFit
    }
    
    
}
