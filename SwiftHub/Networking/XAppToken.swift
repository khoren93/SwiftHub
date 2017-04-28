//
//  XAppToken.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation

private extension Date {
    var isInPast: Bool {
        let now = Date()
        return self.compare(now) == ComparisonResult.orderedAscending
    }
}

struct XAppToken {
    enum DefaultsKeys: String {
        case tokenKey = "XAppTokenKey"
        case tokenExpiry = "XAppTokenExpiry"
    }

    // MARK: - Initializers

    let defaults: UserDefaults

    init(defaults: UserDefaults) {
        self.defaults = defaults
    }

    init() {
        self.defaults = UserDefaults.standard
    }

    // MARK: - Properties

    var token: String? {
        get {
            let key = defaults.string(forKey: DefaultsKeys.tokenKey.rawValue)
            return key
        }
        set(newToken) {
            defaults.set(newToken, forKey: DefaultsKeys.tokenKey.rawValue)
        }
    }

    var expiry: Date? {
        get {
            return defaults.object(forKey: DefaultsKeys.tokenExpiry.rawValue) as? Date
        }
        set(newExpiry) {
            defaults.set(newExpiry, forKey: DefaultsKeys.tokenExpiry.rawValue)
        }
    }

    var expired: Bool {
        if let expiry = expiry {
            return expiry.isInPast
        }
        return true
    }

    var isValid: Bool {
        if let token = token {
            return token.isNotEmpty && !expired
        }

        return false
    }
}
