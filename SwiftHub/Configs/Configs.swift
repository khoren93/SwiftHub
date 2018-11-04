//
//  Configs.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

enum Keys {
    case github, mixpanel

    var apiKey: String {
        switch self {
        case .github: return ""
        case .mixpanel: return "7e428bc407e3612f6d3a4c8f50fd4643"
        }
    }

    var appId: String {
        switch self {
        case .github: return ""
        case .mixpanel: return ""
        }
    }
}

struct Configs {

    struct App {
        static let bundleIdentifier = "com.public.SwiftHub"
        static let IsTesting = true
        static let NavigationTitleFont = UIFont.navigationTitleFont()
    }

    struct Network {
        static let useStaging = false
        static let loggingEnabled = false
        static var baseDomain: String {
            return "https://api.github.com"
        }
        static var baseURL: String {
            return baseDomain //+ "/api/v1"
        }
    }

    struct BaseDimensions {
        static let inset: CGFloat = 10
        static let tabBarHeight: CGFloat = 58
        static let toolBarHeight: CGFloat = 66
        static let navBarWithStatusBarHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 50
        static let textFieldHeight: CGFloat = 40
        static let tableRowHeight: CGFloat = 50
        static let segmentedControlHeight: CGFloat = 30
    }

    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }

    struct UserDefaultsKeys {

    }
}
