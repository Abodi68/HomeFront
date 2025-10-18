import Foundation
import UIKit

struct UserProfile: Codable {
    var fullName: String?
    var preferredName: String?
    var rank: String?
    var branch: String?
    var veteranStatus: String?
    var stateOfResidence: String?
    var bio: String?
    // Store images as Base64 strings for simplicity
    var profileImageBase64: String?
    var coverImageBase64: String?
}

final class UserProfileStore {
    static let shared = UserProfileStore()
    private init() {}

    private func documentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    private func fileURL(for accountID: String) -> URL {
        documentsDirectory().appendingPathComponent("userprofile_\(accountID).json")
    }

    func loadProfile(for accountID: String) -> UserProfile? {
        let url = fileURL(for: accountID)
        guard FileManager.default.fileExists(atPath: url.path) else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let profile = try JSONDecoder().decode(UserProfile.self, from: data)
            return profile
        } catch {
            print("UserProfileStore load error:", error)
            return nil
        }
    }

    func saveProfile(_ profile: UserProfile, for accountID: String) {
        let url = fileURL(for: accountID)
        do {
            let data = try JSONEncoder().encode(profile)
            try data.write(to: url, options: [.atomic])
        } catch {
            print("UserProfileStore save error:", error)
        }
    }
}

extension UserProfile {
    init(fromExisting existing: UserProfile?, updatingWith fields: (preferredName: String?, rank: String?, branch: String?, veteranStatus: String?, stateOfResidence: String?, bio: String?, profileImage: UIImage?, coverImage: UIImage?)) {
        self.fullName = existing?.fullName
        self.preferredName = fields.preferredName ?? existing?.preferredName
        self.rank = fields.rank ?? existing?.rank
        self.branch = fields.branch ?? existing?.branch
        self.veteranStatus = fields.veteranStatus ?? existing?.veteranStatus
        self.stateOfResidence = fields.stateOfResidence ?? existing?.stateOfResidence
        self.bio = fields.bio ?? existing?.bio

        if let image = fields.profileImage, let data = image.jpegData(compressionQuality: 0.85) {
            self.profileImageBase64 = data.base64EncodedString()
        } else {
            self.profileImageBase64 = existing?.profileImageBase64
        }

        if let image = fields.coverImage, let data = image.jpegData(compressionQuality: 0.85) {
            self.coverImageBase64 = data.base64EncodedString()
        } else {
            self.coverImageBase64 = existing?.coverImageBase64
        }
    }

    func profileImage() -> UIImage? {
        guard let b64 = profileImageBase64, let data = Data(base64Encoded: b64) else { return nil }
        return UIImage(data: data)
    }

    func coverImage() -> UIImage? {
        guard let b64 = coverImageBase64, let data = Data(base64Encoded: b64) else { return nil }
        return UIImage(data: data)
    }
}
