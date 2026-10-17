//
//  AppDelegate.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

//    static var shared: AppDelegate? {
//        return UIApplication.shared.delegate as? AppDelegate
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Window setup and the initial screen live in SceneDelegate.

        let libsManager = LibsManager.shared
        libsManager.setupLibs()

        IQKeyboardManager.shared.isEnabled = true

        if Configs.Network.useStaging == true {
            // Logout
            User.removeCurrentUser()
            AuthManager.removeToken()

            // Use Green Dark theme
            var theme = ThemeType.currentTheme()
            if theme.isDark != true {
                theme = theme.toggled()
            }
            theme = theme.withColor(color: .green)
            themeService.switch(theme)
        }

        return true
    }
}
