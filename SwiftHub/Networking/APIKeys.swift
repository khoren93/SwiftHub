//
//  APIKeys.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation

private let minimumKeyLength = 2

// Mark: - API Keys

struct APIKeys {
    let key: String
    let secret: String

    // MARK: Shared Keys

    fileprivate struct SharedKeys {
        static var instance = APIKeys()
    }

    static var sharedKeys: APIKeys {
        get {
            return SharedKeys.instance
        }

        set (newSharedKeys) {
            SharedKeys.instance = newSharedKeys
        }
    }

    // MARK: Initializers

    init() {
        self.init(key: Configs.Keys.GitHubAPIClientKey,
                secret: Configs.Keys.GitHubAPIClientSecret)
    }

    init(key: String, secret: String) {
        self.key = key
        self.secret = secret
    }

    // MARK: Methods

    var stubResponses: Bool {
        return key.characters.count < minimumKeyLength || secret.characters.count < minimumKeyLength
    }

}
