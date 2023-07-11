//
//  Validation.swift
//  MainTarget
//
//  Created by o.sander on 19.06.2023.
//  
//

import Foundation

struct Auth {
    struct Validator { }
}

// MARK: -
// MARK: Password validation
extension Auth {

    enum PasswordRule: String, CaseIterable {
        case notEmpty = "^(?!\\s*$).+"
        case digit = ".*\\d.*"
        case lowercase = ".*[a-z].*"
        case uppercase = ".*[A-Z].*"
        case length = "^.{8,32}$"

        var error: PasswordError {
            switch self {
            case .notEmpty:  return PasswordError.empty
            case .digit:     return PasswordError.oneDigit
            case .lowercase: return PasswordError.oneLowerChar
            case .uppercase: return PasswordError.oneUpperChar
            case .length:    return PasswordError.length
            }
        }
    }

    enum PasswordError: LocalizedError {
        case empty
        case length
        case oneLowerChar
        case oneUpperChar
        case oneDigit
        case confirmMismatch

        var errorDescription: String? {
            switch self {
            case .empty:           return "The field cannot be empty."
            case .length:          return "Password must be at least 8 characters long and less than 32 characters."
            case .oneLowerChar:    return "Password must contain at least one lowercase letter"
            case .oneUpperChar:    return "Password must contain at least one uppercase letter"
            case .oneDigit:        return "Password must contain at least one digit"
            case .confirmMismatch: return "The confirmation does not match the original value."
            }
        }
    }
}

extension Auth.Validator {
    static func validate(password: String) -> [Auth.PasswordError] {
        var errors: [Auth.PasswordError] = []

        for rule in Auth.PasswordRule.allCases {
            let ruleRegex = rule.rawValue
            let rulePredicate = NSPredicate(format: "SELF MATCHES %@", ruleRegex)

            if !rulePredicate.evaluate(with: password) {
                errors.append(rule.error)
            }
        }

        return errors
    }
}

// MARK: -
// MARK: Common
extension Auth.Validator {
    static func isNonEmpty(_ string: String) -> Bool {
        !string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

// MARK: -
// MARK: Email Validation
extension Auth {
    enum EmailRule: String, CaseIterable {
        case notEmpty = "^(?!\\s*$).+"
        case format = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        case length = "^.{1,255}$"

        var error: EmailError {
            switch self {
            case .notEmpty: return EmailError.empty
            case .format:   return EmailError.invalidFormat
            case .length:   return EmailError.length
            }
        }
    }

    enum EmailError: LocalizedError {
        case empty
        case invalidFormat
        case length

        var errorDescription: String? {
            switch self {
            case .empty:         return "The email address cannot be empty."
            case .invalidFormat: return "Invalid email address format."
            case .length:        return "Email address exceeds the maximum length limit."
            }
        }
    }
}

extension Auth.Validator {

    static func validate(email: String) -> [Auth.EmailError] {
        var errors: [Auth.EmailError] = []

        for rule in Auth.EmailRule.allCases {
            let ruleRegex = rule.rawValue
            let rulePredicate = NSPredicate(format: "SELF MATCHES %@", ruleRegex)

            if !rulePredicate.evaluate(with: email) {
                errors.append(rule.error)
            }
        }

        return errors
    }
}
