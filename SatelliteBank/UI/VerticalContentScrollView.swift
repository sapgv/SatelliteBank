//
//  VerticalContentScrollView.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 13.10.2023.
//

import UIKit

final class VerticalContentScrollView: UIScrollView {
    
    private(set) lazy var wrapperView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layout()
    }
    
    func layout() {
        
        self.wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(wrapperView)
        
        self.wrapperView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.wrapperView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.wrapperView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.wrapperView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        self.wrapperView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        
        
    }
    
}
