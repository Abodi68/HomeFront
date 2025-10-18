import Foundation
import CryptoKit

struct LocalAccount: Codable {
    let username: String
    let passwordHash: String
    let fullName: String
}

class LocalAccountManager {
    static let shared = LocalAccountManager()
    private let key = "LocalAccounts"
    
    private(set) var accounts: [LocalAccount] = []
    private(set) var currentAccount: LocalAccount?
    
    private init() {
        load()
        loadCurrentAccount()
    }

    func addAccount(username: String, password: String, fullName: String) {
        let hash = hashPassword(password)
        let account = LocalAccount(username: username, passwordHash: hash, fullName: fullName)
        accounts.append(account)
        save()
    }

    func validate(username: String, password: String) -> Bool {
        let hash = hashPassword(password)
        return accounts.contains(where: {
            $0.username.caseInsensitiveCompare(username) == .orderedSame &&
            $0.passwordHash == hash
        })
    }
    
    func accountExists(username: String) -> Bool {
        return accounts.contains(where: { $0.username.caseInsensitiveCompare(username) == .orderedSame })
    }
    
    func setCurrentAccount(username: String) {
        if let account = accounts.first(where: { $0.username.caseInsensitiveCompare(username) == .orderedSame }) {
            currentAccount = account
            UserDefaults.standard.set(account.username, forKey: "CurrentLoggedInUser")
        }
    }
    
    func loadCurrentAccount() {
        if let username = UserDefaults.standard.string(forKey: "CurrentLoggedInUser"),
           let account = accounts.first(where: { $0.username.caseInsensitiveCompare(username) == .orderedSame }) {
            currentAccount = account
        }
    }
    
    func logout() {
        // Clear the in-memory current account and persisted current user key
        currentAccount = nil
        UserDefaults.standard.removeObject(forKey: "CurrentLoggedInUser")
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(accounts) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let loaded = try? JSONDecoder().decode([LocalAccount].self, from: data) else {
            return
        }
        accounts = loaded
    }
    
    private func hashPassword(_ password: String) -> String {
        let hash = SHA256.hash(data: Data(password.utf8))
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

