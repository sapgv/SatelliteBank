//
//  LoginTextFiledView.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

final class LoginTextFieldView: UIView {
    
    var editingChangedAction: ((LoginPhoneTextField) -> Void)?
    
    private(set) var label: PrimaryLabel = LoginTextFieldPlaceholderLabel()
    
    private(set) var textFiled: LoginPhoneTextField = LoginPhoneTextField()
    
    private(set) var stackViewPadding: CGFloat = 8
    
    private(set) var placeholder: String = "Номер телефона"
    
    private var viewBorderColor: UIColor {
        return self.textFiled.isEditing ? AppColor.primary : UIColor.lightGray
    }
    
    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .fill
        stackView.distribution = .fill
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
        self.setupView()
        self.setupLabel()
        self.setupTextFiled()
        self.updateBorderColor()
        self.layout()
    }
    
    func setupView() {
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.layer.borderWidth = 1
    }
    
    func setupLabel() {
        self.label.text = self.placeholder
        self.label.isHidden = true
    }
    
    func setupTextFiled() {
        self.textFiled.placeholder = self.placeholder
        self.textFiled.delegate = self
        self.textFiled.editingChangedAction = { [weak self] sender in
            self?.editingChangedAction?(sender)
        }
    }
    
    
    func layout() {
     
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.stackView)
        
        self.stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: stackViewPadding).isActive = true
        self.stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: stackViewPadding).isActive = true
        self.stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -stackViewPadding).isActive = true
        self.stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -stackViewPadding).isActive = true
        
        self.stackView.addArrangedSubview(self.label)
        self.stackView.addArrangedSubview(self.textFiled)
        
    }
    
}

extension LoginTextFieldView {
    
    func updateBorderColor() {
        self.layer.borderColor = self.viewBorderColor.cgColor
    }
    
    var isLabelHidden: Bool {
        (self.textFiled.text ?? "").isEmpty && !self.textFiled.isEditing
    }
    
}

extension LoginTextFieldView: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.label.isHidden = isLabelHidden
        self.updateBorderColor()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.label.isHidden = isLabelHidden
        self.updateBorderColor()
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
}
