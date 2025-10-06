//
//  ProfileSetupViewController.swift
//  HomeFront
//

import UIKit

// MARK: - Profile Update Delegate
protocol ProfileUpdateDelegate: AnyObject {
    func profileDidUpdate()
}

class ProfileSetupViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Delegates
    weak var delegateDashboard: DashboardViewController?
    weak var delegateCommunity: CommunityViewController?
    weak var delegateProfile: ProfileViewController?


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

    // MARK: - UI Elements
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

    private lazy var confirmButton = createPrimaryButton(title: "Confirm Information")

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
        lockImmutableFieldsIfNeeded()
    }

    // MARK: - UI Setup
    private func setupUI() {
        [coverImageView, profileImageView, titleLabel, fullNameField, preferredNameField,
         rankField, branchField, statusField, stateField, confirmButton].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            coverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            coverImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            coverImageView.heightAnchor.constraint(equalToConstant: 150),

            profileImageView.centerYAnchor.constraint(equalTo: coverImageView.bottomAnchor),
            profileImageView.centerXAnchor.constraint(equalTo: coverImageView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            fullNameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            fullNameField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            fullNameField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
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

            confirmButton.topAnchor.constraint(equalTo: stateField.bottomAnchor, constant: 30),
            confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 200),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    // MARK: - Pickers
    private func setupPickers() {
        [branchPicker, statusPicker, statePicker].forEach { $0.delegate = self; $0.dataSource = self }
        branchField.inputView = branchPicker
        statusField.inputView = statusPicker
        stateField.inputView = statePicker
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
            showAlert(title: "Missing Information", message: "Please fill out all required fields.")
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
        // Save text info
        UserDefaults.standard.set(name, forKey: "fullName")
        UserDefaults.standard.set(preferredName, forKey: "preferredName")
        UserDefaults.standard.set(rank, forKey: "rank")
        UserDefaults.standard.set(branch, forKey: "branch")
        UserDefaults.standard.set(status, forKey: "veteranStatus")
        UserDefaults.standard.set(state, forKey: "stateOfResidence")
        UserDefaults.standard.set(true, forKey: "profileSetupComplete")
        
        // Save profile image
        if let profileImage = profileImageView.image,
           let profileData = profileImage.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(profileData, forKey: "profileImage")
        }
        
        // Save cover image
        if let coverImage = coverImageView.image,
           let coverData = coverImage.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(coverData, forKey: "coverImage")
        }
        
        // Notify delegates to refresh UI
        delegateProfile?.refreshFromProfile()
        delegateCommunity?.refreshFromProfile()
        delegateDashboard?.refreshFromProfile()
        
        // Dismiss setup
        dismiss(animated: true)
    }


    // MARK: - Load / Lock Fields
    private func loadSavedData() {
        fullNameField.text = UserDefaults.standard.string(forKey: "fullName")
        preferredNameField.text = UserDefaults.standard.string(forKey: "preferredName")
        rankField.text = UserDefaults.standard.string(forKey: "rank")
        branchField.text = UserDefaults.standard.string(forKey: "branch")
        statusField.text = UserDefaults.standard.string(forKey: "veteranStatus")
        stateField.text = UserDefaults.standard.string(forKey: "stateOfResidence")
    }

    private func lockImmutableFieldsIfNeeded() {
        if UserDefaults.standard.bool(forKey: "profileSetupComplete") {
            fullNameField.isEnabled = false
            rankField.isEnabled = false
            branchField.isEnabled = false
        }
    }

    // MARK: - Keyboard
    private func setupKeyboardDismiss() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Helper Alert
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
