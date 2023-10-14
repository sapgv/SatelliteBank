//
//  ScheduleTypeView.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 14.10.2023.
//

import UIKit

final class ScheduleTypeView<T: ScheduleRouteButton>: UIView {
    
    let button: T = T.init()
    
    private var title: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    func commonInit() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.backgroundColor = .secondarySystemBackground
        self.layout()
    }
    
    func layout() {
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(stackView)
        
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        self.stackView.addArrangedSubview(self.button)
        self.stackView.addArrangedSubview(self.title)
        
        self.button.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        self.button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
}
