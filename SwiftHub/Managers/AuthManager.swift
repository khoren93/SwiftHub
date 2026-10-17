//
//  AuthManager.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import KeychainAccess
import RxSwift
import RxCocoa

let loggedIn = BehaviorRelay<Bool>(value: false)

class AuthManager {

    /// The default singleton instance.
    static let shared = AuthManager()

    // MARK: - Properties
    fileprivate let tokenKey = "TokenKey"
    fileprivate let keychain = Keychain(service: Configs.App.bundleIdentifier)

    let tokenChanged = PublishSubject<Token?>()

    init() {
        loggedIn.accept(hasValidToken)
    }

    var token: Token? {
        get {
            guard let jsonString = keychain[tokenKey] else { return nil }
            return Token(jsonString: jsonString)
        }
        set {
            if let token = newValue, let jsonString = token.jsonString() {
                keychain[tokenKey] = jsonString
            } else {
                keychain[tokenKey] = nil
            }
            tokenChanged.onNext(newValue)
            loggedIn.accept(hasValidToken)
        }
    }

    var hasValidToken: Bool {
        return token?.isValid == true
    }

    class func setToken(token: Token) {
        AuthManager.shared.token = token
    }

    class func removeToken() {
        AuthManager.shared.token = nil
    }

    class func tokenValidated() {
        AuthManager.shared.token?.isValid = true
    }
}
