//
//  Untitled.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/14/25.
//

import UIKit

class LoginViewController: BaseViewController {

    private lazy var loginLabel = createLabel(text: "Login / Create Account", fontSize: 28, bold: true)
    private lazy var continueButton = createPrimaryButton(title: "Continue")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginLabel)
        view.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            loginLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 20),
            continueButton.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        continueButton.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
    }
    
    @objc private func continueTapped() {
        // Move to Tab Bar
        let tabBarVC = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "TabBarViewController") as! UITabBarController
        
        tabBarVC.modalTransitionStyle = .flipHorizontal
        tabBarVC.modalPresentationStyle = .fullScreen
        present(tabBarVC, animated: true)
    }
}
