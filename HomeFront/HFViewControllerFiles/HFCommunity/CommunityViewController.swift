//
//  CommunityViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/4/25.
//

import UIKit
import MapKit

class CommunityViewController: BaseViewController {

    private lazy var titleLabel = createLabel(text: "Community", fontSize: 28, bold: true)
    private lazy var eventLabel = createLabel(text: "Events and Centers Closest to You", fontSize: 20, bold: false)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        view.addSubview(eventLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),

            eventLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            eventLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        ])
    }
}

