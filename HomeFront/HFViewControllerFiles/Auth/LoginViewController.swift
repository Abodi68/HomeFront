//
//  Untitled.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/14/25.
//

import UIKit
import Foundation

// Optional protocol to allow compile-time checking if your store exposes `isProfileComplete`
protocol UserProfileStoreProtocol {
    var isProfileComplete: Bool { get }
}

extension UserProfileStore: UserProfileStoreProtocol {
    var isProfileComplete: Bool {
        guard let account = LocalAccountManager.shared.currentAccount else { return false }
        let accountID = account.username
        let profile = UserProfileStore.shared.loadProfile(for: accountID)

        // Required fields
        let fullName = (account.fullName).trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let profileFullName = (profile?.fullName ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let preferredName = (profile?.preferredName ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let rank = (profile?.rank ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let branch = (profile?.branch ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let veteranStatus = (profile?.veteranStatus ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let state = (profile?.stateOfResidence ?? "").trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        let hasFullName = !fullName.isEmpty || !profileFullName.isEmpty
        let hasPreferred = !preferredName.isEmpty
        let hasRank = !rank.isEmpty
        let hasBranch = !branch.isEmpty
        let hasStatus = !veteranStatus.isEmpty
        let hasState = !state.isEmpty

        return hasFullName && hasPreferred && hasRank && hasBranch && hasStatus && hasState
    }
}

class LoginViewController: BaseViewController {

    private enum Notifications {
        static let profileSetupDidComplete = Notification.Name("ProfileSetupDidComplete")
    }

    private var profileStore: AnyObject? { UserProfileStore.shared as AnyObject }

    // MARK: - UI Elements
    
    private lazy var titleLabel: UILabel = {
        let label = createLabel(text: "Welcome Back", fontSize: 28, bold: true)
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    private lazy var usernameField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email or Username"
        field.borderStyle = .roundedRect
        field.autocapitalizationType = .none
        field.keyboardType = .emailAddress
        field.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        return field
    }()
    
    private lazy var passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password"
        field.borderStyle = .roundedRect
        field.isSecureTextEntry = true
        field.backgroundColor = UIColor.white.withAlphaComponent(0.7)
        field.layer.cornerRadius = 10
        field.translatesAutoresizingMaskIntoConstraints = false
        field.font = UIFont.preferredFont(forTextStyle: .body)
        field.adjustsFontForContentSizeCategory = true
        return field
    }()
    
    private lazy var loginButton: UIButton = {
        let button = createPrimaryButton(title: "Log In")
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }()
    
    private lazy var signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("New to HomeFront? Create an Account", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        setupUI()
        setupActions()
        setupKeyboardDismiss()
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
    
    // MARK: - Navigation Helpers
    private func showDashboard() {
        switchToMainInterface()
    }

    private func switchToMainInterface() {
        let makeTabBar: () -> UIViewController = {
            return MainTabBarController()
        }

        // Try to find the active window (iOS 13+ with scenes)
        let window: UIWindow? = {
            // Prefer the active foreground scene
            if let scene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) {
                return scene.windows.first(where: { $0.isKeyWindow }) ?? scene.windows.first
            }
            // Fallback: any window from any scene (non-deprecated)
            if let anyScene = UIApplication.shared.connectedScenes.compactMap({ $0 as? UIWindowScene }).first,
               let anyWindow = anyScene.windows.first(where: { $0.isKeyWindow }) ?? anyScene.windows.first {
                return anyWindow
            }
            return nil
        }()

        // Prepare a lightweight overlay spinner for polish
        let overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        overlayView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])

        guard let targetWindow = window else {
            let tabBar = makeTabBar()
            tabBar.modalPresentationStyle = .fullScreen
            // If no window, at least show the spinner in current view during presentation
            self.view.addSubview(overlayView)
            self.present(tabBar, animated: true) {
                overlayView.removeFromSuperview()
            }
            return
        }

        // Add overlay to window before switching root
        targetWindow.addSubview(overlayView)

        let tabBar = makeTabBar()
        UIView.transition(with: targetWindow, duration: 0.35, options: .transitionCrossDissolve, animations: {
            targetWindow.rootViewController = tabBar
            targetWindow.makeKeyAndVisible()
        }, completion: { _ in
            overlayView.removeFromSuperview()
        })
    }

    private func presentProfileSetupFlow() {
        // Listen for completion from ProfileSetupViewController
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleProfileSetupCompleted),
                                               name: Notifications.profileSetupDidComplete,
                                               object: nil)
        let setupVC = ProfileSetupViewController()
        setupVC.modalPresentationStyle = .fullScreen
        present(setupVC, animated: true)
    }

    @objc private func handleProfileSetupCompleted() {
        NotificationCenter.default.removeObserver(self, name: Notifications.profileSetupDidComplete, object: nil)
        switchToMainInterface()
    }
    
    // MARK: - Actions
    
    @objc private func handleLogin() {
        let username = (usernameField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let password = (passwordField.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if username.isEmpty || password.isEmpty {
            showAlert(title: "Missing Information", message: "Please enter both username and password.")
            return
        }
        if LocalAccountManager.shared.validate(username: username, password: password) {
            LocalAccountManager.shared.setCurrentAccount(username: username)
            // Decide where to go based on whether the user has completed their profile
            if UserProfileStore.shared.isProfileComplete {
                // Profile already complete -> go straight to dashboard
                showDashboard()
            } else {
                // Not complete -> present setup
                presentProfileSetupFlow()
            }
        } else {
            let alert = UIAlertController(
                title: "Login Failed",
                message: "Invalid credentials. Please try again.",
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
    
    // MARK: - Keyboard
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
