import UIKit

class ProfileViewController: BaseViewController, ProfileRefreshable {

    // MARK: - Scroll
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - UI Elements
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.crop.circle")
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let bannerImageView: UIImageView = {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile"
        view.backgroundColor = .systemBackground
        setupUI()
        setupDismissKeyboardGesture()
        loadProfileData()
        setupActions()
    }
    
    // MARK: - Dismiss Keyboard
    @objc private func setupDismissKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }


    // MARK: - UI Setup
    private func setupUI() {
        // Scroll container
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        // Content
        [bannerImageView, profileImageView, fullNameField, preferredNameField, rankField, branchField, veteranStatusField, stateField, bioTextView, editButton].forEach { contentView.addSubview($0) }

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

            // Existing layout within contentView
            bannerImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerImageView.heightAnchor.constraint(equalToConstant: 150),

            profileImageView.topAnchor.constraint(equalTo: bannerImageView.bottomAnchor, constant: -40),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),

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

            // Content bottom
            editButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    

    // MARK: - Actions
    private func setupActions() {
        editButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
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

    // MARK: - Refresh from Profile
    func refreshFromProfile() {
        loadProfileData()
    }

    private func loadProfileData() {
        fullNameField.text = UserDefaults.standard.string(forKey: "fullName") ?? ""
        preferredNameField.text = UserDefaults.standard.string(forKey: "preferredName") ?? ""
        rankField.text = UserDefaults.standard.string(forKey: "rank") ?? ""
        branchField.text = UserDefaults.standard.string(forKey: "branch") ?? ""
        veteranStatusField.text = UserDefaults.standard.string(forKey: "veteranStatus") ?? ""
        stateField.text = UserDefaults.standard.string(forKey: "stateOfResidence") ?? UserDefaults.standard.string(forKey: "state") ?? ""
        bioTextView.text = UserDefaults.standard.string(forKey: "bio") ?? ""

        if let profileData = UserDefaults.standard.data(forKey: "profileImage"),
           let profile = UIImage(data: profileData) {
            profileImageView.image = profile
        }

        if let coverData = UserDefaults.standard.data(forKey: "coverImage"),
           let cover = UIImage(data: coverData) {
            bannerImageView.image = cover
        } else if let bannerData = UserDefaults.standard.data(forKey: "bannerImage"),
                  let banner = UIImage(data: bannerData) {
            bannerImageView.image = banner
        }
    }
}

