//
//  GreetingBuilder.swift
//  HomeFront
//
//  Created by AI Assistant on 20251015.
//

import Foundation

/// Utility responsible for constructing user-facing greeting messages.
struct GreetingBuilder {
    /// Builds a greeting text using available profile information.
    /// - Parameters:
    ///   - preferredName: The user's preferred name, if any.
    ///   - fullName: The user's full name, used if no preferred name is provided.
    ///   - rank: An optional rank/title to prefix the name with.
    /// - Returns: A localized, human-friendly greeting string.

    static func greetingText(preferredName: String?, fullName: String?, rank: String?) -> String {
        let baseName: String? = preferredName?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty
            ?? fullName?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty

        // Build a display name with optional rank prefix
        let displayName: String? = {
            guard let name = baseName else { return nil }
            if let rank = rank?.trimmingCharacters(in: .whitespacesAndNewlines).nilIfEmpty {
                return "\(rank) \(name)"
            } else {
                return name
            }
        }()

        // Choose a time-of-day greeting
        let salutation = timeOfDayGreeting()

        if let displayName = displayName {
            return "\(salutation), \(displayName)!"
        } else {
            // Fallback if we lack any name information
            return "\(salutation)!"
        }
    }

    /// Returns a simple, localized time-of-day greeting.
    private static func timeOfDayGreeting(date: Date = Date(), calendar: Calendar = .current) -> String {
        let hour = calendar.component(.hour, from: date)
        switch hour {
        case 5..<12: return NSLocalizedString("Good morning", comment: "Morning greeting")
        case 12..<17: return NSLocalizedString("Good afternoon", comment: "Afternoon greeting")
        case 17..<22: return NSLocalizedString("Good evening", comment: "Evening greeting")
        default: return NSLocalizedString("Hello", comment: "Generic greeting")
        }
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
