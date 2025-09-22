//
//  ResourcesViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 9/4/25.
//

import Foundation
import UIKit

class ResourcesViewController: BaseViewController {
    
        private let scrollView = UIScrollView()
        private let contentStack = UIStackView()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Resources"
            view.backgroundColor = .systemBackground
            
            setupScrollView()
            buildResourceSections()
        }
        
        private func setupScrollView() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            contentStack.axis = .vertical
            contentStack.spacing = 10 // OG 10, testing different values
            contentStack.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(scrollView)
            scrollView.addSubview(contentStack)
            
            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
                contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
                contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
                contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32)
            ])
        }
        
        private func buildResourceSections() {
            addSection(title: "National Resources", resources: ResourceData.nationalResources)
            addSection(title: "Missouri Resources", resources: ResourceData.missouriResources)
        }
        
        private func addSection(title: String, resources: [Resource]) {
            // Section header
            
            let header = UILabel()
            header.text = title
            header.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            header.textColor = .label
            contentStack.addArrangedSubview(header)
            
            // Add cards
            for resource in resources {
                let card = ResourceCard(resource: resource)
                contentStack.addArrangedSubview(card)
            }
        }
    }

class ResourceCard : UIView {
    
    //instantiate separate label parts for Title and Description of resources
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private var url: String?
    
    init(resource: Resource) {
        super.init(frame: .zero)
        self.url = resource.url
        setupUI(title: resource.title, description: resource.description)
        
        // tap gesture to open URL in Safari (or other default Browser)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openURL))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
    private func setupUI(title: String, description: String) {
        layer.cornerRadius = 12
        backgroundColor = UIColor.systemGray6
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 0
        
        descriptionLabel.text = description
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
            ])
    }
    
    @objc private func openURL() {
        if let urlString = url, let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
    
}
