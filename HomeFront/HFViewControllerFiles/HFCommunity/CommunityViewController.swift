//
//  CommunityViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/4/25.
//

import UIKit

class CommunityViewController: BaseViewController {

    private lazy var titleLabel = createLabel(text: "Community", fontSize: 28, bold: true)
    private lazy var joinButton = createPrimaryButton(title: "Join Discussion")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(joinButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            joinButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            joinButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            joinButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
}

