//
//  Token.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import ObjectMapper

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

struct Token: Mappable {

    var isValid = false

    // Basic
    var basicToken: String?

    // Personal Access Token
    var personalToken: String?

    // OAuth2
    var accessToken: String?
    var tokenType: String?
    var scope: String?

    init?(map: Map) {}
    init() {}

    init(basicToken: String) {
        self.basicToken = basicToken
    }

    init(personalToken: String) {
        self.personalToken = personalToken
    }

    mutating func mapping(map: Map) {
        isValid <- map["valid"]
        basicToken <- map["basic_token"]
        personalToken <- map["personal_token"]
        accessToken <- map["access_token"]
        tokenType <- map["token_type"]
        scope <- map["scope"]
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
