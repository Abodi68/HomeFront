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
            navBar.barTintColor = UIColor.hf_primary
            navBar.tintColor = .white
            navBar.titleTextAttributes = [
                .foregroundColor: UIColor.white,
                .font: UIFont.boldSystemFont(ofSize: 20)
            ]
            navBar.isTranslucent = false
        }
        
        /// Tab bar styling (if inside tab bar controller)
        if let tabBar = tabBarController?.tabBar {
            tabBar.barTintColor = UIColor.hf_background
            tabBar.tintColor = UIColor.hf_primary
            tabBar.unselectedItemTintColor = UIColor.lightGray
            tabBar.isTranslucent = false
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
}
