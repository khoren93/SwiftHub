//
//  Token.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation

enum TokenType {
    case basic(token: String)
    case personal(token: String)
    case oAuth(token: String)
    case unauthorized

    var description: String {
        switch self {
        case .basic: return "basic"
        case .personal: return "personal"
        case .oAuth: return "OAuth"
        case .unauthorized: return "unauthorized"
        }
    }
}

struct Token: Codable {

    var isValid = false

    // Basic
    var basicToken: String?

    // Personal Access Token
    var personalToken: String?

    // OAuth2
    var accessToken: String?
    var tokenType: String?
    var scope: String?

    init() {}

    init(basicToken: String) {
        self.basicToken = basicToken
    }

    init(personalToken: String) {
        self.personalToken = personalToken
    }

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        isValid = map["valid"] ?? isValid
        basicToken = map["basic_token"]
        personalToken = map["personal_token"]
        accessToken = map["access_token"]
        tokenType = map["token_type"]
        scope = map["scope"]
    }

    func encode(to encoder: Encoder) throws {
        var map = encoder.container(keyedBy: JSONKey.self)
        try map.encode(isValid, forKey: "valid")
        try map.encode(basicToken, forKey: "basic_token")
        try map.encode(personalToken, forKey: "personal_token")
        try map.encode(accessToken, forKey: "access_token")
        try map.encode(tokenType, forKey: "token_type")
        try map.encode(scope, forKey: "scope")
    }

    func type() -> TokenType {
        if let token = basicToken {
            return .basic(token: token)
        }
        if let token = personalToken {
            return .personal(token: token)
        }
        if let token = accessToken {
            return .oAuth(token: token)
        }
        return .unauthorized
    }
}
