//
//  SignupViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 10/5/25.
//

import UIKit

class SignupViewController: BaseViewController {

    // MARK: - UI Elements

    private lazy var titleLabel = createLabel(text: "Create Your Account", fontSize: 28, bold: true)

    private lazy var nameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Full Name"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .words
        field.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email Address"
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

    private lazy var confirmPasswordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Confirm Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()

    private lazy var signupButton = createPrimaryButton(title: "Create Account")

    private lazy var backToLoginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Already have an account? Log in", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        setupUI()
        setupActions()
    }

    // MARK: - Setup

    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(signupButton)
        view.addSubview(backToLoginButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),

            nameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            nameField.heightAnchor.constraint(equalToConstant: 44),

            emailField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 20),
            emailField.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 44),

            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 20),
            passwordField.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            passwordField.heightAnchor.constraint(equalToConstant: 44),

            confirmPasswordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmPasswordField.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 20),
            confirmPasswordField.widthAnchor.constraint(equalTo: nameField.widthAnchor),
            confirmPasswordField.heightAnchor.constraint(equalToConstant: 44),

            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: 30),
            signupButton.widthAnchor.constraint(equalToConstant: 180),
            signupButton.heightAnchor.constraint(equalToConstant: 44),

            backToLoginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backToLoginButton.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20)
        ])
    }

    private func setupActions() {
        signupButton.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(handleBackToLogin), for: .touchUpInside)
    }

    // MARK: - Actions

    @objc private func handleSignup() {
        guard let password = passwordField.text,
              let confirm = confirmPasswordField.text,
              password == confirm else {
            showAlert(title: "Passwords Don't Match", message: "Please make sure both password fields match.")
            return
        }

        // For now, this will just send the user back to login
        // Later, this will handle Firebase Auth createUser()
        let alert = UIAlertController(
            title: "Account Created",
            message: "Your account has been successfully created! Please log in.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    @objc private func handleBackToLogin() {
        dismiss(animated: true)
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
