//
//  UIViewController + Extensions.swift
//  SatelliteBank
//
//  Created by Grigory Sapogov on 12.10.2023.
//

import UIKit

public struct KeyboardAssociatedKeys {
    
    public static var tapGestureRecognizer: UITapGestureRecognizer?
    public static var isKeyboard = false
    public static var isKeyboardNotification = false
}

extension UIViewController {
    
    var tapGestureRecognizer: UITapGestureRecognizer? {
        get {
            guard let value = objc_getAssociatedObject(self, &KeyboardAssociatedKeys.tapGestureRecognizer) as? UITapGestureRecognizer else {
                return nil
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &KeyboardAssociatedKeys.tapGestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var isKeyboard: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &KeyboardAssociatedKeys.isKeyboard) as? Bool else {
                return false
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &KeyboardAssociatedKeys.isKeyboard, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    var isKeyboardNotification: Bool {
        get {
            guard let value = objc_getAssociatedObject(self, &KeyboardAssociatedKeys.isKeyboardNotification) as? Bool else {
                return false
            }
            return value
        }
        set {
            objc_setAssociatedObject(self, &KeyboardAssociatedKeys.isKeyboardNotification, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func addKeyboardNotification(isTap: Bool = true) {
        if isKeyboardNotification {
            return
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppearNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidAppear), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name: UIResponder.keyboardDidHideNotification, object: nil)

        if isTap {
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
            tapGestureRecognizer!.cancelsTouchesInView = false
            view.addGestureRecognizer(tapGestureRecognizer!)
        }
        isKeyboardNotification = true
    }
    
    func removeKeyboardNotification() {
        if isKeyboardNotification {
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
            if tapGestureRecognizer != nil {
                view.removeGestureRecognizer(tapGestureRecognizer!)
                tapGestureRecognizer = nil
            }
            isKeyboardNotification = false
        }
    }
    
    
    // MARK: - Keyboard
    
    @objc func keyboardWillAppear(notification: Notification) {}
    @objc func keyboardWillHide(notification: Notification) {}
    @objc func keyboardDidAppear(notification: Notification) {}
    @objc func keyboardDidHide(notification: Notification) {}
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppearNotification(notification: Notification) {
        isKeyboard = true
        if responds(to: #selector(keyboardWillAppear)) {
            keyboardWillAppear(notification: notification)
        }
    }
    
    @objc func keyboardWillHideNotification(notification: Notification) {
        isKeyboard = false
        if responds(to: #selector(keyboardWillHide)) {
            keyboardWillHide(notification: notification)
        }
    }
    
    var safeAreaBottomInset: CGFloat {
        guard #available(iOS 11, *) else { return 0 }
        return self.view.safeAreaInsets.bottom
    }
    
}

