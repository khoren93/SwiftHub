//
//  LibsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import SnapKit
import IQKeyboardManagerSwift
import CocoaLumberjackSwift
import Chameleon
import Kingfisher
import FLEX
import Fabric
import Crashlytics
import Intercom
import NVActivityIndicatorView
import NSObject_Rx
import SwifterSwift

/// The manager class for configuring all libraries used in app.
class LibsManager {

    /// The default singleton instance.
    static let shared = LibsManager()

    func setupLibs(with window: UIWindow? = nil) {
        let libsManager = LibsManager.shared
        libsManager.setupCocoaLumberjack()
        libsManager.setupFabric()
        libsManager.setupAnalytics()
        libsManager.setupChameleon()
        libsManager.setupFLEX()
        libsManager.setupKeyboardManager()
        libsManager.setupIntercom()
        libsManager.setupActivityView()
    }

    func setupChameleon() {
        UIApplication.shared.statusBarStyle = .lightContent
        Chameleon.setGlobalThemeUsingPrimaryColor(.primaryColor(), withSecondaryColor: .secondaryColor(), andContentStyle: .contrast)
        UIButton.appearance(whenContainedInInstancesOf: [UITableView.self]).backgroundColor = UIColor.clear
    }

    func setupActivityView() {
        NVActivityIndicatorView.DEFAULT_TYPE = .ballPulseSync
        NVActivityIndicatorView.DEFAULT_COLOR = .secondaryColor()
    }

    func setupKeyboardManager() {
        IQKeyboardManager.sharedManager().enable = true
    }

    func setupKingfisher() {
        // Set maximum disk cache size for default cache. Default value is 0, which means no limit.
        ImageCache.default.maxDiskCacheSize = UInt(500 * 1024 * 1024) // 500 MB

        // Set longest time duration of the cache being stored in disk. Default value is 1 week
        ImageCache.default.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 7) // 1 week

        // Set timeout duration for default image downloader. Default value is 15 sec.
        ImageDownloader.default.downloadTimeout = 15.0 // 15 sec
    }

    func setupCocoaLumberjack() {
        DDLog.add(DDTTYLogger.sharedInstance) // TTY = Xcode console
        DDLog.add(DDASLLogger.sharedInstance) // ASL = Apple System Logs

        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    func setupFLEX() {
        FLEXManager.shared().isNetworkDebuggingEnabled = true
    }

    func setupFabric() {
        //Fabric.with([Crashlytics.self])
        //Fabric.sharedSDK().debug = false
    }

    func setupIntercom() {
        IntercomManager.setup()
    }

    func setupAnalytics() {
        Analytics.setup()
    }
}

extension LibsManager {

    func showFlex() {
        FLEXManager.shared().showExplorer()
    }

    func removeKingfisherCache(completion handler: (() -> Void)?) {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache {
            handler?()
        }
    }
}
