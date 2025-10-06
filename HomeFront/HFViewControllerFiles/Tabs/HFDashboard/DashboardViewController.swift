//
//  DashboardViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 20250904.
//  updated 20251005


import UIKit



class DashboardViewController: BaseViewController {

    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        updateGreeting()
    }

    private func setupUI() {
        view.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            greetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }

    private func updateGreeting() {
        let preferredName = UserDefaults.standard.string(forKey: "preferredName") ?? (UserDefaults.standard.string(forKey: "fullName") ?? "Friend")
        let rank = UserDefaults.standard.string(forKey: "rank") ?? ""

        // Determine time of day
        let hour = Calendar.current.component(.hour, from: Date())
        let timeGreeting: String
        switch hour {
        case 5..<12:
            timeGreeting = "Good Morning"
        case 12..<17:
            timeGreeting = "Good Afternoon"
        default:
            timeGreeting = "Good Evening"
        }

        if !rank.isEmpty {
            greetingLabel.text = "\(timeGreeting), \(rank) \(preferredName)"
        } else {
            greetingLabel.text = "\(timeGreeting), \(preferredName)"
        }
    }
}

extension DashboardViewController: ProfileRefreshable {
    func refreshFromProfile() {
        updateGreeting()          // Refresh greeting or dashboard info
    }
}

