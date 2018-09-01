//
//  AuthManager.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import KeychainAccess
import ObjectMapper
import RxSwift

class AuthManager {

    /// The default singleton instance.
    static let shared = AuthManager()

    // MARK: - Properties
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = Keychain(service: Configs.App.bundleIdentifier)

    let tokenChanged = PublishSubject<Void>()

    var token: Token? {
        get {
            guard let jsonString = keychain[tokenKey] else { return nil }
            return Mapper<Token>().map(JSONString: jsonString)
        }
        set {
            if let accessToken = newValue, let jsonString = accessToken.toJSONString() {
                keychain[tokenKey] = jsonString
            } else {
                keychain[tokenKey] = nil
            }
            tokenChanged.onNext(())
        }
    }

    var hasToken: Bool {
        if let token = token?.basicToken {
            return !token.isEmpty
        }
        return false
    }

    class func removeToken() {
        AuthManager.shared.token = nil
    }
}
