//
//  ProfileViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/4/25.
//

import UIKit

class ProfileViewController: BaseViewController {

    private lazy var titleLabel = createLabel(text: "Profile", fontSize: 28, bold: true)
    private lazy var editButton = createPrimaryButton(title: "Edit Profile")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(editButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            editButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            editButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            editButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
}
