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
import FirebaseAnalytics

let analytics = Umbrella.Analytics<SwifthubEvent>()

enum SwifthubEvent {
    case appAds(enabled: Bool)
    case appNightMode(enabled: Bool)
    case appTheme(color: String)
    case appLanguage(language: String)
    case appCacheRemoved
    case userInvited(success: Bool)
    case whatsNew
    case flexOpened

    case login(login: String, type: String)
    case logout
    case search(keyword: String)
    case repoLanguage(language: String)
    case repository(fullname: String)
    case user(login: String)
    case userEvents(login: String)
    case repositoryEvents(fullname: String)
    case issues(fullname: String)
    case source(fullname: String)
    case readme(fullname: String)
    case linesCount(fullname: String)
}

extension SwifthubEvent: Umbrella.EventType {

    func name(for provider: ProviderType) -> String? {
        switch self {
        case .appAds: return "ads_changed"
        case .appNightMode: return "night_mode_changed"
        case .appTheme: return "theme"
        case .appLanguage: return "language"
        case .appCacheRemoved: return "cache_removed"
        case .userInvited: return "user_invited"
        case .whatsNew: return "whats_new"
        case .flexOpened: return "flex_opened"
        case .login: return "login"
        case .logout: return "logout"
        case .search: return "search"
        case .repoLanguage: return "repo_language"
        case .repository: return "repository"
        case .user: return "user"
        case .userEvents: return "user_events"
        case .repositoryEvents: return "repository_events"
        case .issues: return "issues"
        case .source: return "source"
        case .readme: return "readme"
        case .linesCount: return "lines_count"
        }
    }

    func parameters(for provider: ProviderType) -> [String: Any]? {
        switch self {
        case .appAds(let enabled),
             .appNightMode(let enabled):
            return ["enabled": enabled]
        case .appTheme(let color):
            return ["color": color]
        case .appLanguage(let language):
            return ["language": language]
        case .userInvited(let success):
            return ["success": success]
        case .login(let login, let type):
            return ["login": login, "type": type]
        case .search(let keyword):
            return ["keyword": keyword]
        case .repoLanguage(let language):
            return ["language": language]
        case .user(let login),
             .userEvents(let login):
            return ["login": login]
        case .repository(let fullname),
             .repositoryEvents(let fullname),
             .issues(let fullname),
             .source(let fullname),
             .readme(let fullname),
             .linesCount(let fullname):
            return ["fullname": fullname]
        default:
            return nil
        }
    }
}

extension Umbrella.Analytics {

    func identify(userId: String) {
        Mixpanel.sharedInstance()?.identify(userId)
        FirebaseAnalytics.Analytics.setUserID(userId)
    }

    func updateUser(name: String, email: String) {
        Mixpanel.sharedInstance()?.people.set("$name", to: name)
        Mixpanel.sharedInstance()?.people.set("$email", to: email)
        FirebaseAnalytics.Analytics.setUserProperty(name, forName: "$name")
        FirebaseAnalytics.Analytics.setUserProperty(email, forName: "$email")
    }

    func updateUser(ads enabled: Bool) {
        Mixpanel.sharedInstance()?.people.set("$ads_enabled", to: enabled)
        FirebaseAnalytics.Analytics.setUserProperty("\(enabled)", forName: "$ads_enabled")
    }

    func updateUser(nightMode enabled: Bool) {
        Mixpanel.sharedInstance()?.people.set("$night_mode_enabled", to: enabled)
        FirebaseAnalytics.Analytics.setUserProperty("\(enabled)", forName: "$night_mode_enabled")
    }

    func updateUser(colorTheme theme: String) {
        Mixpanel.sharedInstance()?.people.set("$color_theme", to: theme)
        FirebaseAnalytics.Analytics.setUserProperty(theme, forName: "$color_theme")
    }

    func reset() {
        Mixpanel.sharedInstance()?.reset()
        FirebaseAnalytics.Analytics.resetAnalyticsData()
    }
}
