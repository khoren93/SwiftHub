//
//  AnalyticsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import Umbrella
import Mixpanel

let analytics = Analytics<SwifthubEvent>()

enum SwifthubEvent {
    case appLaunch
    case login(username: String)
    case logout
}

extension SwifthubEvent: Umbrella.EventType {

    func name(for provider: ProviderType) -> String? {
        switch self {
        case .appLaunch: return "app_launch"
        case .login: return "login"
        case .logout: return "logout"
        }
    }

    func parameters(for provider: ProviderType) -> [String: Any]? {
        switch self {
        case .login(let username):
            return ["username": username]
        default:
            return nil
        }
    }
}

extension Analytics {

    func identify(userId: String) {
        Mixpanel.sharedInstance()?.identify(userId)
    }

    func updateUser(name: String, email: String) {
        Mixpanel.sharedInstance()?.people.set("$name", to: name)
        Mixpanel.sharedInstance()?.people.set("$email", to: email)
    }
}
