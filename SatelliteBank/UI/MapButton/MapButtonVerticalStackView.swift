//
//  MapButtonVerticalStackView.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class MapButtonVerticalStackView: UIStackView {
    
    private(set) var buttons: [MapButton] = []
    
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
        for view in self.arrangedSubviews {
            view.removeFromSuperview()
        }
        for button in self.buttons {
            self.addArrangedSubview(button)
        }
    }
    
    func setButtons(buttons: [MapButton]) {
        self.buttons = buttons
        self.layout()
    }
    
}
