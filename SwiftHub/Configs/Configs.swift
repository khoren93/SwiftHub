//
//  Configs.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

// All keys are demonstrative and used for the test.
enum Keys {
    case github

    var apiKey: String {
        switch self {
        case .github: return "5a39979251c0452a9476bd45c82a14d8e98c3fb3"
        }
    }

    var appId: String {
        switch self {
        case .github: return "00cbdbffb01ec72e280a"
        }
    }
}

struct Configs {

    struct App {
        static let githubUrl = "https://github.com/khoren93/SwiftHub"
        static let githubScope = "user+repo+notifications+read:org"
        static let bundleIdentifier = "com.public.SwiftHub"
    }

    struct Network {
        static let useStaging = false  // set true for tests and generating screenshots with fastlane
        static let loggingEnabled = false
        static let githubBaseUrl = "https://api.github.com"
        static let trendingGithubBaseUrl = "https://api.gitterapp.com"
        static let githistoryBaseUrl = "https://github.githistory.xyz"
        static let starHistoryBaseUrl = "https://star-history.t9t.io"
        static let profileSummaryBaseUrl = "https://profile-summary-for-github.com"
        static let githubSkylineBaseUrl = "https://skyline.github.com"
    }

    struct BaseDimensions {
        static let inset: CGFloat = 8
        static let tabBarHeight: CGFloat = 58
        static let toolBarHeight: CGFloat = 66
        static let navBarWithStatusBarHeight: CGFloat = 64
        static let cornerRadius: CGFloat = 5
        static let borderWidth: CGFloat = 1
        static let buttonHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 40
        static let tableRowHeight: CGFloat = 36
        static let segmentedControlHeight: CGFloat = 40
    }

    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        static let Tmp = NSTemporaryDirectory()
    }
}
