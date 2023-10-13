//
//  LoginViewController.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit
import SkyFloatingLabelTextField

final class LoginViewController: UIViewController {
    
    private let padding: CGFloat = 16
    
    private lazy var skipButton: LoginViewSkipButton = LoginViewSkipButton()
    
    private lazy var logoImageView: LoginViewLogoImageView = LoginViewLogoImageView()
    
    private lazy var phoneTitleLabel: LoginViewTitleLabel = LoginViewTitleLabel()
    
    private lazy var messageTitleLabel: LoginViewMessageLabel = LoginViewMessageLabel()
    
    private lazy var loginTextFieldView: LoginTextFieldView = LoginTextFieldView()
    
    private lazy var submitButton: LoginViewSubmitButton = LoginViewSubmitButton()
    
    private lazy var alternativeLogin: LoginViewAlternativeLoginButton = LoginViewAlternativeLoginButton()
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var wrapperView = UIView()
    
    private(set) var bottomConstraint: NSLayoutConstraint?
    
    private(set) var wrapperViewBottomConstraint: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupScrollView()
        self.setupLoginTextFieldView()
        self.addKeyboardNotification()
        self.layoutView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.updateSubmitButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupScrollView() {
        self.scrollView.bounces = true
        self.scrollView.alwaysBounceVertical = true
        self.scrollView.showsVerticalScrollIndicator = false
    }
    
    private func setupLoginTextFieldView() {
        self.loginTextFieldView.editingChangedAction = { [weak self] textField in
            self?.updateSubmitButton()
        }
    }
    
    private func updateSubmitButton() {
        self.submitButton.isEnabled = self.loginTextFieldView.textFiled.text.isValidPhone
        self.submitButton.backgroundColor = self.submitButton.isEnabled ? AppColor.primary : .lightGray
    }
    
    //MARK: - Keyboard
    
    override func keyboardWillAppear(notification: Notification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
        
        self.bottomConstraint?.constant = -keyboardHeight
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    override func keyboardWillHide(notification: Notification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        bottomConstraint?.constant = 0
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
}

//MARK: - Layout

extension LoginViewController {
 
    private func layoutView() {
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.wrapperView.translatesAutoresizingMaskIntoConstraints = false
        
        self.skipButton.translatesAutoresizingMaskIntoConstraints = false
        self.logoImageView.translatesAutoresizingMaskIntoConstraints = false
        self.loginTextFieldView.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.phoneTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.alternativeLogin.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(wrapperView)

        self.wrapperView.addSubview(self.skipButton)
        self.wrapperView.addSubview(self.logoImageView)
        self.wrapperView.addSubview(self.loginTextFieldView)
        self.wrapperView.addSubview(self.submitButton)
        self.wrapperView.addSubview(self.phoneTitleLabel)
        self.wrapperView.addSubview(self.messageTitleLabel)
        self.wrapperView.addSubview(self.alternativeLogin)

        self.scrollView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        self.bottomConstraint = self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        self.bottomConstraint?.isActive = true

        self.wrapperView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0).isActive = true
        self.wrapperView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 0).isActive = true
        self.wrapperView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor, constant: 0).isActive = true
        self.wrapperView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor, constant: 0).isActive = true

        self.wrapperView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor, constant: 0).isActive = true
        
        self.skipButton.topAnchor.constraint(equalTo: self.wrapperView.topAnchor, constant: padding).isActive = true
        self.skipButton.trailingAnchor.constraint(equalTo: self.wrapperView.trailingAnchor, constant: -padding).isActive = true
        self.skipButton.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.logoImageView.topAnchor.constraint(equalTo: self.skipButton.bottomAnchor, constant: padding).isActive = true
        self.logoImageView.centerXAnchor.constraint(equalTo: self.wrapperView.centerXAnchor, constant: 0).isActive = true
        self.logoImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.phoneTitleLabel.leadingAnchor.constraint(equalTo: self.wrapperView.leadingAnchor, constant: padding).isActive = true
        self.phoneTitleLabel.trailingAnchor.constraint(equalTo: self.wrapperView.trailingAnchor, constant: -padding).isActive = true
        self.phoneTitleLabel.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: padding).isActive = true
        self.phoneTitleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.messageTitleLabel.leadingAnchor.constraint(equalTo: self.wrapperView.leadingAnchor, constant: padding).isActive = true
        self.messageTitleLabel.trailingAnchor.constraint(equalTo: self.wrapperView.trailingAnchor, constant: -padding).isActive = true
        self.messageTitleLabel.topAnchor.constraint(equalTo: self.phoneTitleLabel.bottomAnchor, constant: padding).isActive = true
        self.messageTitleLabel.heightAnchor.constraint(equalToConstant: 44).isActive = true

        self.loginTextFieldView.leadingAnchor.constraint(equalTo: self.wrapperView.leadingAnchor, constant: padding).isActive = true
        self.loginTextFieldView.trailingAnchor.constraint(equalTo: self.wrapperView.trailingAnchor, constant: -padding).isActive = true
        self.loginTextFieldView.topAnchor.constraint(equalTo: self.messageTitleLabel.bottomAnchor, constant: padding).isActive = true
        self.loginTextFieldView.heightAnchor.constraint(equalToConstant: 64).isActive = true

        self.submitButton.leadingAnchor.constraint(equalTo: self.wrapperView.leadingAnchor, constant: padding).isActive = true
        self.submitButton.topAnchor.constraint(equalTo: self.loginTextFieldView.bottomAnchor, constant: padding).isActive = true
        self.submitButton.trailingAnchor.constraint(equalTo: self.wrapperView.trailingAnchor, constant: -padding).isActive = true
        self.submitButton.heightAnchor.constraint(equalTo: self.loginTextFieldView.heightAnchor).isActive = true

        self.alternativeLogin.leadingAnchor.constraint(equalTo: self.wrapperView.leadingAnchor, constant: padding).isActive = true
        self.alternativeLogin.topAnchor.constraint(equalTo: self.submitButton.bottomAnchor, constant: padding).isActive = true
        self.alternativeLogin.trailingAnchor.constraint(equalTo: self.wrapperView.trailingAnchor, constant: -padding).isActive = true

        self.wrapperViewBottomConstraint = self.alternativeLogin.bottomAnchor.constraint(equalTo: self.wrapperView.bottomAnchor, constant: -padding)
        self.wrapperViewBottomConstraint?.isActive = true
        
    }
    
}
