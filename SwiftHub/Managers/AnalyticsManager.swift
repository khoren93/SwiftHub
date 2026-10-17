//
//  AnalyticsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import FirebaseAnalytics

let analytics = Analytics()

enum AnalyticsUserEventType {
    case colorTheme(value: String)
    case nightMode(value: Bool)
}

extension AnalyticsUserEventType {

    func name() -> String {
        switch self {
        case .nightMode: return "night_mode_enabled"
        case .colorTheme: return "color_theme"
        }
    }

    func value() -> Any {
        switch self {
        case .colorTheme(let value):
            return value
        case .nightMode(let value):
            return value
        }
    }
}

enum AnalyticsEventType {
    case appNightMode(enabled: Bool)
    case appTheme(color: String)
    case appCacheRemoved
    case flexOpened

    case login(login: String, type: String)
    case logout
    case search(keyword: String)
    case repoLanguage(language: String)
    case repository(fullname: String)
    case repositoryStar(fullname: String)
    case user(login: String)
    case userEvents(login: String)
    case repositoryEvents(fullname: String)
    case issues(fullname: String)
    case source(fullname: String)
    case readme(fullname: String)
}

extension AnalyticsEventType {

    func name() -> String {
        switch self {
        case .appNightMode: return "night_mode_changed"
        case .appTheme: return "theme"
        case .appCacheRemoved: return "cache_removed"
        case .flexOpened: return "flex_opened"
        case .login: return "login"
        case .logout: return "logout"
        case .search: return "search"
        case .repoLanguage: return "repo_language"
        case .repository: return "repository"
        case .repositoryStar: return "repository_starred"
        case .user: return "user"
        case .userEvents: return "user_events"
        case .repositoryEvents: return "repository_events"
        case .issues: return "issues"
        case .source: return "source"
        case .readme: return "readme"
        }
    }

    func parameters() -> [String: Any]? {
        switch self {
        case .appNightMode(let enabled):
            return ["enabled": enabled]
        case .appTheme(let color):
            return ["color": color]
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
             .repositoryStar(let fullname),
             .repositoryEvents(let fullname),
             .issues(let fullname),
             .source(let fullname),
             .readme(let fullname):
            return ["fullname": fullname]
        default:
            return nil
        }
    }
}

class Analytics {
    func log(_ event: AnalyticsEventType) {
        let name = event.name()
        let parameters = event.parameters()
        FirebaseAnalytics.Analytics.logEvent(name, parameters: parameters)
    }

    func set(_ userProperty: AnalyticsUserEventType) {
        let name = userProperty.name()
        let value = userProperty.value()
        FirebaseAnalytics.Analytics.setUserProperty("\(value)", forName: name)
    }
}

extension Analytics {

    func identify(userId: String) {
        FirebaseAnalytics.Analytics.setUserID(userId)
    }

    func reset() {
        FirebaseAnalytics.Analytics.resetAnalyticsData()
    }
}
