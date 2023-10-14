//
//  BonusViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 15.10.2023.
//

import UIKit

final class BonusViewController: UIViewController {
    
    var bonus: IBonus?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 1
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let addressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let bonusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.updateView()
        self.layout()
    }
    
    private func updateView() {
        guard let bonus = self.bonus else { return }
        self.titleLabel.text = bonus.name
        self.addressLabel.text = bonus.address
        self.bonusLabel.text = "Кешбэк \(bonus.percent) процентов"
        self.titleLabel.isHidden = bonus.name.isEmpty
        self.addressLabel.isHidden = bonus.address.isEmpty
        self.bonusLabel.isHidden = bonus.percent == 0
    }
    
    private let padding: CGFloat = 16
    
    private func layout() {
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.stackView)
        
        self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: padding).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding).isActive = true
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.addressLabel)
        self.stackView.addArrangedSubview(self.bonusLabel)
        
    }
    
    
    
}
