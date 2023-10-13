//
//  ScaleMapStackView.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class ScaleMapStackView: UIStackView {
    
    private(set) var scalePlusMapButton: ScalePlusMapButton = ScalePlusMapButton()
    
    private(set) var scaleMinusMapButton: ScaleMinusMapButton = ScaleMinusMapButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.setupStackView()
        self.layout()
    }
    
    func setupStackView() {
        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 8
        self.alignment = .center
    }
    
    func layout() {
        self.addArrangedSubview(scalePlusMapButton)
        self.addArrangedSubview(scaleMinusMapButton)
    }
    
}
