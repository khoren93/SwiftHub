//
//  LibsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import Chameleon
import FLEX

/// The manager class for configuring all libraries used in app.
class LibsManager {

    /// The default singleton instance.
    static let sharedInstance = LibsManager()

    func setupChameleon() {
        UIApplication.shared.statusBarStyle = .lightContent
        Chameleon.setGlobalThemeUsingPrimaryColor(.primaryColor(), withSecondaryColor: .secondaryColor(), andContentStyle: .contrast)
    }

    func setupKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
    }

    func setupFLEX() {
        FLEXManager.shared().isNetworkDebuggingEnabled = true
        FLEXManager.shared().showExplorer()
    }

    func setupAnalytics() {
        Analytics.setup()
    }

}
