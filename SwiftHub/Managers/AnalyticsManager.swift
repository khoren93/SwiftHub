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
    case appTheme(color: String)
    case appLanguage(language: String)

    case login(login: String)
    case logout
    case search(keyword: String)
    case repository(fullname: String)
    case user(login: String)
}

extension SwifthubEvent: Umbrella.EventType {

    func name(for provider: ProviderType) -> String? {
        switch self {
        case .appTheme: return "Theme"
        case .appLanguage: return "Language"
        case .login: return "Login"
        case .logout: return "Logout"
        case .search: return "Search"
        case .repository: return "Repository"
        case .user: return "User"
        }
    }

    func parameters(for provider: ProviderType) -> [String: Any]? {
        switch self {
        case .appTheme(let color):
            return ["Color": color]
        case .appLanguage(let language):
            return ["Language": language]
        case .login(let login):
            return ["Login": login]
        case .search(let keyword):
            return ["Keyword": keyword]
        case .repository(let fullname):
            return ["Fullname": fullname]
        case .user(let login):
            return ["Login": login]
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

    func logout() {
        Mixpanel.sharedInstance()?.reset()
    }
}
