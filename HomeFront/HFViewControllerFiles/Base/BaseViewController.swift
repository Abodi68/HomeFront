//
//  BaseViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/14/25.
//

import UIKit
import Foundation

class BaseViewController: UIViewController {

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBaseStyling()
    }

    // MARK: - Base Styling
    private func setupBaseStyling() {
        /// Background color
        view.backgroundColor = UIColor.hf_background
        
        /// Navigation bar styling (if embedded)
        if let navBar = navigationController?.navigationBar {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.hf_primary
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
            navBar.standardAppearance = appearance
            navBar.scrollEdgeAppearance = appearance
            navBar.compactAppearance = appearance
            navBar.tintColor = .white
        }
        
        /// Tab bar styling (if inside tab bar controller)
        if let tabBar = tabBarController?.tabBar {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.hf_background
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
            tabBar.tintColor = UIColor.hf_primary
            tabBar.unselectedItemTintColor = UIColor.lightGray
        }
    }
    
    // MARK: - Common UI Helpers
    
    /// Create a standard button with consistent styling
    func createPrimaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.hf_button
        button.layer.cornerRadius = 10
        applyShadow(to: button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }
    
    /// Apply consistent shadow styling
    func applyShadow(to view: UIView, color: UIColor = .black, opacity: Float = 0.6, offset: CGSize = CGSize(width: 2, height: 2), radius: CGFloat = 4) {
        view.layer.shadowColor = color.cgColor
        view.layer.shadowOpacity = opacity
        view.layer.shadowOffset = offset
        view.layer.shadowRadius = radius
    }
    
    /// Create a standard label with optional bold
    func createLabel(text: String, fontSize: CGFloat = 24, bold: Bool = false, color: UIColor = .white) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = color
        label.font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    /// Create a standard text field matching UI.
    func createTextField(
        placeholder: String,
        fontSize: CGFloat = 18,
        bold: Bool = false,
        textColor: UIColor = .label,
        backgroundColor: UIColor = UIColor.systemGray6,
        isSecure: Bool = false,
        autocapitalization: UITextAutocapitalizationType = .words
    ) -> UITextField {
        
        let textField = UITextField()
        
        textField.placeholder = placeholder
        textField.textColor = textColor
        textField.font = bold ? UIFont.boldSystemFont(ofSize: fontSize) : UIFont.systemFont(ofSize: fontSize)
        textField.backgroundColor = backgroundColor
        textField.borderStyle = .roundedRect
        textField.layer.cornerRadius = 10
        textField.isSecureTextEntry = isSecure
        textField.autocapitalizationType = autocapitalization
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }
    
    func showAlert(title: String, message: String, actionTitle: String = "OK") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: .default))
        self.present(alert, animated: true)
    }
}

