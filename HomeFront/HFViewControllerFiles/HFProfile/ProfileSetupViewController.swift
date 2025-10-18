//
//  ProfileSetupViewController.swift
//  HomeFront
//

import UIKit

// MARK: - Notification Name Extension
extension Notification.Name {
    static let profileDidUpdate = Notification.Name("profileDidUpdate")
}

// MARK: - Profile Update Delegate
protocol ProfileUpdateDelegate: AnyObject {
    func profileDidUpdate()
}

class ProfileSetupViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // Delegates
    weak var delegateProfile: ProfileRefreshable?
    weak var delegateDashboard: ProfileRefreshable?
    weak var delegateCommunity: ProfileRefreshable?

    private var currentAccountID: String? {
        return LocalAccountManager.shared.currentAccount?.username
    }

    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.keyboardDismissMode = .interactive
        return sv
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private lazy var coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray4
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 12
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray3
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 50
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private lazy var titleLabel = createLabel(text: "Set Up Your Profile", fontSize: 28, bold: true)

    private lazy var fullNameField = createTextField(placeholder: "Full Name")
    private lazy var preferredNameField = createTextField(placeholder: "Preferred Name (optional)")
    private lazy var rankField = createTextField(placeholder: "Rank")
    private lazy var branchField = createTextField(placeholder: "Branch of Service")
    private lazy var statusField = createTextField(placeholder: "Veteran Status")
    private lazy var stateField = createTextField(placeholder: "State of Residence")
    
    private let bioTextView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.layer.cornerRadius = 8
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.systemGray4.cgColor
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.text = "Tell us about yourself..."
        tv.textColor = .secondaryLabel
        return tv
    }()

    private lazy var confirmButton = createPrimaryButton(title: "Confirm Information")

    // MARK: - Data Sources
    private let branches = ["Army", "Navy", "Air Force", "Marines", "Coast Guard", "Space Force"]
    private let veteranStatus = ["Active Duty", "Reserve", "National Guard", "Veteran"]
    private let states = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado",
        "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho",
        "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
        "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
        "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
        "New Hampshire", "New Jersey", "New Mexico", "New York",
        "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",
        "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota",
        "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington",
        "West Virginia", "Wisconsin", "Wyoming"
    ]

    // MARK: - Pickers
    private let branchPicker = UIPickerView()
    private let statusPicker = UIPickerView()
    private let statePicker = UIPickerView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Profile Setup"

        setupUI()
        setupPickers()
        setupActions()
        setupImageTapGestures()
        setupKeyboardDismiss()
        loadSavedData()
        bioTextView.delegate = self
    }
    
    private func findFirstResponder(in root: UIView) -> UIView? {
        if root.isFirstResponder { return root }
        for sub in root.subviews {
            if let found = findFirstResponder(in: sub) { return found }
        }
        return nil
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [coverImageView, profileImageView, titleLabel, fullNameField, preferredNameField,
         rankField, branchField, statusField, stateField, bioTextView, confirmButton].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),

            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        // NOTE: Keep these dimensions in sync with ProfileViewController (cover: 0.9 width x 150h, profile: 100x100 with 50 corner radius)
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            coverImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            coverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            coverImageView.heightAnchor.constraint(equalToConstant: 150),

            profileImageView.centerYAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            fullNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            fullNameField.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fullNameField.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            fullNameField.heightAnchor.constraint(equalToConstant: 44),

            preferredNameField.topAnchor.constraint(equalTo: fullNameField.bottomAnchor, constant: 15),
            preferredNameField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            preferredNameField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            preferredNameField.heightAnchor.constraint(equalTo: fullNameField.heightAnchor),

            rankField.topAnchor.constraint(equalTo: preferredNameField.bottomAnchor, constant: 15),
            rankField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            rankField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            rankField.heightAnchor.constraint(equalTo: fullNameField.heightAnchor),

            branchField.topAnchor.constraint(equalTo: rankField.bottomAnchor, constant: 15),
            branchField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            branchField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            branchField.heightAnchor.constraint(equalTo: fullNameField.heightAnchor),

            statusField.topAnchor.constraint(equalTo: branchField.bottomAnchor, constant: 15),
            statusField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            statusField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            statusField.heightAnchor.constraint(equalTo: fullNameField.heightAnchor),

            stateField.topAnchor.constraint(equalTo: statusField.bottomAnchor, constant: 15),
            stateField.centerXAnchor.constraint(equalTo: fullNameField.centerXAnchor),
            stateField.widthAnchor.constraint(equalTo: fullNameField.widthAnchor),
            stateField.heightAnchor.constraint(equalTo: fullNameField.heightAnchor),
            
            bioTextView.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 15),
            bioTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bioTextView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85),
            bioTextView.heightAnchor.constraint(equalToConstant: 120),

            confirmButton.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 30),
            confirmButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 200),
            confirmButton.heightAnchor.constraint(equalToConstant: 44),
            confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    // MARK: - Pickers
    private func setupPickers() {
        [branchPicker, statusPicker, statePicker].forEach { $0.delegate = self; $0.dataSource = self }
        branchField.inputView = branchPicker
        statusField.inputView = statusPicker
        stateField.inputView = statePicker

        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexible, done], animated: false)
        branchField.inputAccessoryView = toolbar
        statusField.inputAccessoryView = toolbar
        stateField.inputAccessoryView = toolbar
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case branchPicker: return branches.count
        case statusPicker: return veteranStatus.count
        default: return states.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case branchPicker: return branches[row]
        case statusPicker: return veteranStatus[row]
        default: return states[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case branchPicker:
            branchField.text = branches[row]
            branchField.resignFirstResponder()
        case statusPicker:
            statusField.text = veteranStatus[row]
            statusField.resignFirstResponder()
        default:
            stateField.text = states[row]
            stateField.resignFirstResponder()
        }
    }

    // MARK: - Image Tap
    private func setupImageTapGestures() {
        let coverTap = UITapGestureRecognizer(target: self, action: #selector(selectCoverImage))
        coverImageView.addGestureRecognizer(coverTap)
        let profileTap = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(profileTap)
    }

    @objc private func selectCoverImage() { presentImagePicker(for: coverImageView) }
    @objc private func selectProfileImage() { presentImagePicker(for: profileImageView) }

    private func presentImagePicker(for imageView: UIImageView) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        picker.accessibilityHint = imageView == profileImageView ? "profile" : "cover"
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let edited = info[.editedImage] as? UIImage { selectedImage = edited }
        else if let original = info[.originalImage] as? UIImage { selectedImage = original }
        if let image = selectedImage {
            if picker.accessibilityHint == "profile" { profileImageView.image = image }
            else { coverImageView.image = image }
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { picker.dismiss(animated: true) }

    // MARK: - Actions
    private func setupActions() {
        confirmButton.addTarget(self, action: #selector(confirmTapped), for: .touchUpInside)
    }

    @objc private func confirmTapped() {
        guard let fullName = fullNameField.text, !fullName.isEmpty,
              let rank = rankField.text, !rank.isEmpty,
              let branch = branchField.text, !branch.isEmpty,
              let status = statusField.text, !status.isEmpty,
              let state = stateField.text, !state.isEmpty else {
            self.showAlert(title: "Missing Information", message: "Please fill out all required fields.")
            return
        }

        let preferredName = preferredNameField.text ?? fullName

        let message = """
        Please confirm your details:

        Name: \(fullName)
        Preferred Name: \(preferredName)
        Rank: \(rank)
        Branch: \(branch)
        Status: \(status)
        State: \(state)
        """

        let alert = UIAlertController(title: "Confirm Information", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Edit", style: .cancel))
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            self.saveProfileData(name: fullName, preferredName: preferredName, rank: rank, branch: branch, status: status, state: state)
        }))
        present(alert, animated: true)
    }

    // MARK: - Save Profile
    private func saveProfileData(
        name: String,
        preferredName: String,
        rank: String,
        branch: String,
        status: String,
        state: String
    ) {
        guard let accountID = currentAccountID else {
            self.showAlert(title: "Not Logged In", message: "You must be logged in to save your profile.")
            return
        }

        let store = UserProfileStore.shared
        let existing = store.loadProfile(for: accountID)

        // Build updated profile
        var profile = UserProfile(
            fullName: LocalAccountManager.shared.currentAccount?.fullName ?? existing?.fullName,
            preferredName: preferredName,
            rank: rank,
            branch: branch,
            veteranStatus: status,
            stateOfResidence: state,
            bio: existing?.bio,
            profileImageBase64: existing?.profileImageBase64,
            coverImageBase64: existing?.coverImageBase64
        )
        
        let bioText = (bioTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        if !bioText.isEmpty && bioText != "Tell us about yourself..." {
            profile.bio = bioText
        }

        if let img = profileImageView.image, let data = img.jpegData(compressionQuality: 0.85) {
            profile.profileImageBase64 = data.base64EncodedString()
        }
        if let img = coverImageView.image, let data = img.jpegData(compressionQuality: 0.85) {
            profile.coverImageBase64 = data.base64EncodedString()
        }

        store.saveProfile(profile, for: accountID)

        // Notify listeners
        NotificationCenter.default.post(name: .profileDidUpdate, object: nil)
        NotificationCenter.default.post(name: Notification.Name("ProfileSetupDidComplete"), object: nil)
        delegateProfile?.refreshFromProfile()
        delegateDashboard?.refreshFromProfile()
        delegateCommunity?.refreshFromProfile()

        // Dismiss
        dismiss(animated: true)
    }

    // MARK: - Load / Lock Fields
    private func loadSavedData() {
        let account = LocalAccountManager.shared.currentAccount
        let accountID = account?.username
        let profile = accountID.flatMap { UserProfileStore.shared.loadProfile(for: $0) }

        fullNameField.text = account?.fullName ?? profile?.fullName
        preferredNameField.text = profile?.preferredName
        rankField.text = profile?.rank
        branchField.text = profile?.branch
        statusField.text = profile?.veteranStatus
        stateField.text = profile?.stateOfResidence
        
        if let bio = profile?.bio, !bio.isEmpty {
            bioTextView.text = bio
            bioTextView.textColor = .label
        }

        if let img = profile?.profileImage() { profileImageView.image = img }
        if let cover = profile?.coverImage() { coverImageView.image = cover }
    }

    // MARK: - Keyboard
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        contentView.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UITextViewDelegate (Placeholder behavior)
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView === bioTextView && textView.text == "Tell us about yourself..." {
            textView.text = ""
            textView.textColor = .label
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView === bioTextView {
            let trimmed = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty {
                textView.text = "Tell us about yourself..."
                textView.textColor = .secondaryLabel
            } else {
                textView.text = trimmed
                textView.textColor = .label
            }
        }
    }


// MARK: - Keyboard handling
private func registerForKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(_:)),
                                          name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard(_:)),
                                          name: UIResponder.keyboardWillHideNotification, object: nil)
}

@objc private func adjustForKeyboard(_ notification: Notification) {
    guard let userInfo = notification.userInfo,
          let endFrameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

    let endFrame = view.convert(endFrameValue.cgRectValue, from: view.window)
    let isHiding = notification.name == UIResponder.keyboardWillHideNotification
    let bottomInset = isHiding ? 0 : max(0, view.bounds.maxY - endFrame.origin.y)

    var contentInset = scrollView.contentInset
    contentInset.bottom = bottomInset + 16
    scrollView.contentInset = contentInset
    scrollView.scrollIndicatorInsets = contentInset

    // If a field is active, ensure it's visible
    if let firstResponder = findFirstResponder(in: view) {
        scrollView.scrollRectToVisible(firstResponder.convert(firstResponder.bounds, to: scrollView), animated: true)
    }
}

deinit {
    NotificationCenter.default.removeObserver(self)
}

}

