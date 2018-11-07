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
    case appTheme(color: String)
    case appLanguage(language: String)

    case login(username: String)
    case logout
    case search(keyword: String)
    case repository(fullname: String)
    case user(login: String)
}

extension SwifthubEvent: Umbrella.EventType {

    func name(for provider: ProviderType) -> String? {
        switch self {
        case .appLaunch: return "app_launch"
        case .appTheme: return "app_theme"
        case .appLanguage: return "app_language"
        case .login: return "login"
        case .logout: return "logout"
        case .search: return "search"
        case .repository: return "repository"
        case .user: return "user"
        }
    }

    func parameters(for provider: ProviderType) -> [String: Any]? {
        switch self {
        case .appTheme(let color):
            return ["color": color]
        case .appLanguage(let language):
            return ["language": language]
        case .login(let username):
            return ["username": username]
        case .search(let keyword):
            return ["keyword": keyword]
        case .repository(let fullname):
            return ["fullname": fullname]
        case .user(let login):
            return ["login": login]
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
