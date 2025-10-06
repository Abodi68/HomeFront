//
//  Untitled.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/14/25.
//

import UIKit

class LoginViewController: BaseViewController {

    // MARK: - UI Elements
    
    private lazy var titleLabel = createLabel(text: "Welcome Back", fontSize: 28, bold: true)
    
    private lazy var usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email or Username"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        field.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    private lazy var loginButton = createPrimaryButton(title: "Log In")
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New to HomeFront? Create an Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupUI()
        setupActions()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            
            usernameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            usernameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            usernameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            usernameField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: usernameField.widthAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            loginButton.widthAnchor.constraint(equalToConstant: 160),
            loginButton.heightAnchor.constraint(equalToConstant: 44),
            
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
    }
    
    // MARK: - Actions
    
    @objc private func handleLogin() {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""

        // Temporary test login
        if username.lowercased() == "test" && password == "1234" {
            let mainTabBar = MainTabBarController()
            mainTabBar.modalPresentationStyle = .fullScreen
            present(mainTabBar, animated: true)
        } else {
            let alert = UIAlertController(
                title: "Login Failed",
                message: "Invalid credentials. Try 'test' / '1234' for now.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }

    @objc private func handleSignup() {
        let signupVC = SignupViewController()
        signupVC.modalPresentationStyle = .fullScreen
        signupVC.modalTransitionStyle = .crossDissolve
        present(signupVC, animated: true)
    }
}

