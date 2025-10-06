//
//  CheckInViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/4/25.
//


//MARK: --- NOT USING THIS AT THIS TIME ---

import UIKit

    class CheckInViewController: BaseViewController {
        
        private let label = UILabel()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Daily Check-In"
            
    //        let _checkinLabel = createLabel(text: "How are you feeling today?")
    //        label.text = "How are you feeling today?"
    //        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
    //        label.textAlignment = .center
    //        label.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(label)
            
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
