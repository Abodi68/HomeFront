//
//  LandingViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/5/25.
//


import Foundation
import UIKit

class LandingViewController: BaseViewController {

    // MARK: - UI Elements
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "jp-valery--ph1Fqhx5Ko-unsplash"))
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let overlayView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var welcomeLabel = createLabel(text: "Welcome to Homefront", fontSize: 32, bold: true)
    private lazy var enterButton = createPrimaryButton(title: "Enter")

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add subviews
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(welcomeLabel)
        view.addSubview(enterButton)

        // Layout constraints
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),

            enterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            enterButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            enterButton.widthAnchor.constraint(equalToConstant: 140)
        ])

        // Button action
        enterButton.addTarget(self, action: #selector(enterTapped), for: .touchUpInside)

        // Start invisible for fade-in
        view.alpha = 0.0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 2.0, delay: 0.0, options: [.curveEaseInOut]) {
            self.view.alpha = 1.0
        }
    }

    // MARK: - Navigation
    @objc private func enterTapped() {
        let loginVC = LoginViewController()
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
}
