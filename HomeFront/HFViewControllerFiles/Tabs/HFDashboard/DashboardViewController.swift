//
//  DashboardViewController.swift
//  HomeFront
//
//  Created by Alex Bodi on 20250904.
//  updated 20251005


import UIKit



final class DashboardViewController: BaseViewController {

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let vStack = UIStackView()

    // Greeting
    private let greetingTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        label.numberOfLines = 2
        label.accessibilityIdentifier = "greeting_title"
        return label
    }()

    private let greetingSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        label.accessibilityIdentifier = "greeting_subtitle"
        return label
    }()
    
    private let branchIconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .tertiaryLabel
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.accessibilityIdentifier = "branch_icon"
        return iv
    }()

    // Quick Actions
    private let quickActionsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()

    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.accessibilityIdentifier = "quick_actions_edit"
        button.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        //button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        return button
    }()

    private lazy var communityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Community", for: .normal)
        button.setImage(UIImage(systemName: "person.3"), for: .normal)
        button.tintColor = .systemBlue
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        button.layer.cornerRadius = 10
        button.backgroundColor = .secondarySystemBackground
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        button.accessibilityIdentifier = "quick_actions_community"
        button.addTarget(self, action: #selector(openCommunityTapped), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        //button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -6, bottom: 0, right: 6)
        return button
    }()

    // Stats
    private let statsCard = UIView()
    private let statsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
    }()

    private let connectionsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.accessibilityIdentifier = "stats_connections"
        return label
    }()

    private let postsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.accessibilityIdentifier = "stats_posts"
        return label
    }()

    private let messagesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.accessibilityIdentifier = "stats_messages"
        return label
    }()

    // Recent Activity
    private let recentTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Recent Activity"
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.accessibilityIdentifier = "recent_activity_title"
        return label
    }()

    private let recentStack = UIStackView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        updateGreeting()
        populateStats()
        populateRecent()
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileDidUpdate), name: .profileDidUpdate, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateGreeting()
    }

    // MARK: - Setup UI
    private func setupUI() {
        // Scroll + content
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // VStack
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.spacing = 16
        vStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])

        // Greeting container with branch icon on the right
        let greetingTextStack = UIStackView(arrangedSubviews: [greetingTitleLabel, greetingSubtitleLabel])
        greetingTextStack.axis = .vertical
        greetingTextStack.spacing = 6

        let greetingHeader = UIStackView(arrangedSubviews: [greetingTextStack, branchIconView])
        greetingHeader.axis = .horizontal
        greetingHeader.alignment = .top
        greetingHeader.spacing = 12
        vStack.addArrangedSubview(greetingHeader)

        NSLayoutConstraint.activate([
            branchIconView.widthAnchor.constraint(equalToConstant: 115),
            branchIconView.heightAnchor.constraint(equalToConstant: 115)
        ])

        // Quick actions
        quickActionsStack.addArrangedSubview(editProfileButton)
        quickActionsStack.addArrangedSubview(communityButton)
        vStack.addArrangedSubview(quickActionsStack)

        // Stats card styling
        statsCard.backgroundColor = .secondarySystemBackground
        statsCard.layer.cornerRadius = 12
        statsCard.translatesAutoresizingMaskIntoConstraints = false
        statsCard.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        let statsContainer = UIStackView(arrangedSubviews: [connectionsLabel, postsLabel, messagesLabel])
        statsContainer.axis = .horizontal
        statsContainer.alignment = .fill
        statsContainer.distribution = .fillEqually
        statsContainer.spacing = 8

        statsCard.addSubview(statsContainer)
        statsContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            statsContainer.topAnchor.constraint(equalTo: statsCard.topAnchor, constant: 12),
            statsContainer.leadingAnchor.constraint(equalTo: statsCard.leadingAnchor, constant: 12),
            statsContainer.trailingAnchor.constraint(equalTo: statsCard.trailingAnchor, constant: -12),
            statsContainer.bottomAnchor.constraint(equalTo: statsCard.bottomAnchor, constant: -12)
        ])
        vStack.addArrangedSubview(statsCard)

        // Recent activity
        recentStack.axis = .vertical
        recentStack.alignment = .fill
        recentStack.spacing = 8
        vStack.addArrangedSubview(recentTitleLabel)
        vStack.addArrangedSubview(recentStack)
    }

    // MARK: - Content
    private func populateStats() {
        // Placeholder numbers; in a real app, fetch and update
        let connections = 12
        let posts = 3
        let messages = 5
        connectionsLabel.text = "\nConnections\n\(connections)"
        postsLabel.text = "\nPosts\n\(posts)"
        messagesLabel.text = "\nMessages\n\(messages)"
    }

    private func populateRecent() {
        recentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let items = [
            ("Welcome to HomeFront!", "Thanks for joining our community."),
            ("Profile Setup", "Add a bio so we can learn more about you!"),
            ("Explore Community", "Soon you will be able to link up with others here, standby!")
        ]
        for (title, subtitle) in items {
            let cell = makeRecentCell(title: title, subtitle: subtitle)
            recentStack.addArrangedSubview(cell)
        }
    }

    private func makeRecentCell(title: String, subtitle: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemBackground
        container.layer.cornerRadius = 10

        let titleLabel = UILabel()
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.text = title

        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = subtitle

        let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stack.axis = .vertical
        stack.spacing = 4

        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        return container
    }

    // MARK: - Greeting
    private func updateGreeting() {
        if !Thread.isMainThread {
            return DispatchQueue.main.async { [weak self] in self?.updateGreeting() }
        }
        let account = LocalAccountManager.shared.currentAccount
        let accountID = account?.username
        let profile = accountID.flatMap { UserProfileStore.shared.loadProfile(for: $0) }
        let text = GreetingBuilder.greetingText(
            preferredName: profile?.preferredName,
            fullName: account?.fullName ?? profile?.fullName,
            rank: profile?.rank
        )
        greetingTitleLabel.text = text

        // Subheadline suggestion line
        if let branch = profile?.branch, !branch.isEmpty {
            greetingSubtitleLabel.text = "Welcome back. \nBranch: \(branch)"
        } else {
            greetingSubtitleLabel.text = "Welcome back."
        }
        
        // Update branch icon based on profile branch
        let assetName: String?
        switch (profile?.branch ?? "").lowercased() {
        case let s where s.contains("army"): assetName = "branch_army"
        case let s where s.contains("navy"): assetName = "branch_navy"
        case let s where s.contains("air force"): assetName = "branch_af"
        case let s where s.contains("marines"): assetName = "branch_marines"
        case let s where s.contains("coast guard"): assetName = "branch_coastguard"
        case let s where s.contains("space force"): assetName = "branch_spaceforce"
        default: assetName = nil
        }
        if let name = assetName, let img = UIImage(named: name) {
            branchIconView.image = img.withRenderingMode(.alwaysOriginal)
            branchIconView.isHidden = false
        } else {
            branchIconView.image = nil
            branchIconView.isHidden = true
        }
    }

    // MARK: - Actions
    @objc private func handleProfileDidUpdate() {
        updateGreeting()
        populateStats()
        populateRecent()
    }

    @objc private func editProfileTapped() {
        let profileSetupVC = ProfileSetupViewController()
        // Hook up delegates if available
        profileSetupVC.delegateDashboard = self
        if let tabBar = self.tabBarController {
            let communityNav = tabBar.viewControllers?.dropFirst().first as? UINavigationController
            profileSetupVC.delegateCommunity = communityNav?.viewControllers.first as? CommunityViewController
            profileSetupVC.delegateProfile = (tabBar.viewControllers?.last as? UINavigationController)?.viewControllers.first as? ProfileRefreshable
        }
        profileSetupVC.modalPresentationStyle = .fullScreen
        present(profileSetupVC, animated: true)
    }

    @objc private func openCommunityTapped() {
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 1 // assume Community is second tab
        }
    }
}

extension DashboardViewController: ProfileRefreshable {
    func refreshFromProfile() {
        updateGreeting()
        populateStats()
        populateRecent()
    }
}

