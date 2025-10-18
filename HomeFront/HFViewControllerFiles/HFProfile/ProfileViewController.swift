import UIKit


class ProfileViewController: BaseViewController, ProfileRefreshable{

    private var currentAccountID: String? {
        // Use username as stable account identifier
        return LocalAccountManager.shared.currentAccount?.username
    }

    // MARK: - Scroll
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - UI Elements
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.systemGray5
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var fullNameField = createTextField(placeholder: "Full Name", fontSize: 18, bold: true)
    private lazy var preferredNameField = createTextField(placeholder: "Preferred Name", fontSize: 18)
    private lazy var rankField = createTextField(placeholder: "Rank", fontSize: 18)
    private lazy var branchField = createTextField(placeholder: "Branch", fontSize: 18)
    private lazy var veteranStatusField = createTextField(placeholder: "Veteran Status", fontSize: 18)
    private lazy var stateField = createTextField(placeholder: "State of Residence", fontSize: 18)
    private let bioTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 8
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private lazy var editButton = createPrimaryButton(title: "Update Profile")
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setupUI()
        loadProfileData()
        setupActions()
        makeFieldsReadOnly()
    }
    

    // MARK: - UI Setup
    private func setupUI() {
        // Scroll container
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Content
        [coverImageView, profileImageView, fullNameField, preferredNameField, rankField, branchField, veteranStatusField, stateField, bioTextView, editButton].forEach { contentView.addSubview($0) }
        contentView.addSubview(logoutButton)

        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // NOTE: Dimensions mirrored from ProfileSetupViewController (cover: 0.9 width x 150h, profile: 100x100 with 50 corner radius)
            // Existing layout within contentView
            coverImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            coverImageView.heightAnchor.constraint(equalToConstant: 150),

            profileImageView.centerYAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),
            
            
            fullNameField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            fullNameField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fullNameField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            fullNameField.heightAnchor.constraint(equalToConstant: 44),

            preferredNameField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 10),
            preferredNameField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            preferredNameField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            preferredNameField.heightAnchor.constraint(equalToConstant: 44),

            rankField.topAnchor.constraint(equalTo: preferredNameField.bottomAnchor, constant: 10),
            rankField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            rankField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            rankField.heightAnchor.constraint(equalToConstant: 44),

            branchField.topAnchor.constraint(equalTo: rankField.bottomAnchor, constant: 10),
            branchField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            branchField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            branchField.heightAnchor.constraint(equalToConstant: 44),

            veteranStatusField.topAnchor.constraint(equalTo: branchField.bottomAnchor, constant: 10),
            veteranStatusField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            veteranStatusField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            veteranStatusField.heightAnchor.constraint(equalToConstant: 44),

            stateField.topAnchor.constraint(equalTo: veteranStatusField.bottomAnchor, constant: 10),
            stateField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            stateField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            stateField.heightAnchor.constraint(equalToConstant: 44),

            bioTextView.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 10),
            bioTextView.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            bioTextView.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            bioTextView.heightAnchor.constraint(equalToConstant: 100),

            editButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20),
            editButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 160),
            editButton.heightAnchor.constraint(equalToConstant: 44),

            logoutButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoutButton.topAnchor.constraint(equalTo: editButton.bottomAnchor, constant: 20),
            logoutButton.widthAnchor.constraint(equalToConstant: 120),
            logoutButton.heightAnchor.constraint(equalToConstant: 36),
            logoutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    

    // MARK: - Actions
    private func setupActions() {
        editButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
        logoutButton.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
    }
    
    private func makeFieldsReadOnly() {
        fullNameField.isEnabled = false
        preferredNameField.isEnabled = false
        rankField.isEnabled = false
        branchField.isEnabled = false
        veteranStatusField.isEnabled = false
        stateField.isEnabled = false
        bioTextView.isEditable = false
        bioTextView.isSelectable = false
        
        let fields: [UIView] = [fullNameField, preferredNameField, rankField, branchField, veteranStatusField, stateField, bioTextView]
        fields.forEach { view in
            view.alpha = 0.8
            if let tf = view as? UITextField { tf.borderStyle = .roundedRect }
            if let tv = view as? UITextView { tv.layer.borderColor = UIColor.systemGray3.cgColor }
        }
    }

    @objc private func editProfileTapped() {
        let profileSetupVC = ProfileSetupViewController()
        
        // Connect delegates
        profileSetupVC.delegateProfile = self
        
        if let tabBar = self.tabBarController {
            let dashboardNav = tabBar.viewControllers?[0] as? UINavigationController
            let communityNav = tabBar.viewControllers?[1] as? UINavigationController
            profileSetupVC.delegateDashboard = dashboardNav?.viewControllers.first as? DashboardViewController
            profileSetupVC.delegateCommunity = communityNav?.viewControllers.first as? CommunityViewController
        }
        
        profileSetupVC.modalPresentationStyle = .fullScreen
        present(profileSetupVC, animated: true)
    }

    @objc private func handleLogout() {
        let alert = UIAlertController(title: "Log Out", message: "Are you sure you want to log out?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive) { _ in
            // Clear session via account manager
            LocalAccountManager.shared.logout()
            // Present LoginViewController modally
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true) {
                if let tabBar = self.tabBarController {
                    tabBar.selectedIndex = 0
                }
            }
        })
        present(alert, animated: true)
    }

    // MARK: - Refresh from Profile
    func refreshFromProfile() {
        loadProfileData()
    }

    private func loadProfileData() {
        guard let accountID = currentAccountID else {
            // Fallback to empty if no user
            fullNameField.text = LocalAccountManager.shared.currentAccount?.fullName ?? ""
            preferredNameField.text = ""
            rankField.text = ""
            branchField.text = ""
            veteranStatusField.text = ""
            stateField.text = ""
            bioTextView.text = ""
            profileImageView.image = UIImage(systemName: "person.crop.circle")
            coverImageView.image = nil
            return
        }

        // Load per-user profile from store
        let store = UserProfileStore.shared
        let profile = store.loadProfile(for: accountID)

        // Populate fields, preferring account fullName if present
        fullNameField.text = LocalAccountManager.shared.currentAccount?.fullName ?? profile?.fullName ?? ""
        preferredNameField.text = profile?.preferredName ?? ""
        rankField.text = profile?.rank ?? ""
        branchField.text = profile?.branch ?? ""
        veteranStatusField.text = profile?.veteranStatus ?? ""
        stateField.text = profile?.stateOfResidence ?? ""
        bioTextView.text = profile?.bio ?? ""

        if let img = profile?.profileImage() {
            profileImageView.image = img
        }

        if let cover = profile?.coverImage() {
            coverImageView.image = cover
        }
    }
}

