//
//  DashboardViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/4/25.
//

import UIKit

class DashboardViewController: BaseViewController {

    private lazy var titleLabel = createLabel(text: "Dashboard", fontSize: 28, bold: true)
    private lazy var myResourcesButton = createPrimaryButton(title: "My Resources")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(myResourcesButton)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            myResourcesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            myResourcesButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            myResourcesButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
}
