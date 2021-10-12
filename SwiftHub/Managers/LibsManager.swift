//
//  LibsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SnapKit
import IQKeyboardManagerSwift
import CocoaLumberjack
import Kingfisher
#if DEBUG
import FLEX
#endif
import FirebaseCrashlytics
import NSObject_Rx
import RxViewController
import RxOptional
import RxGesture
import SwifterSwift
import SwiftDate
import Hero
import KafkaRefresh
import Mixpanel
import Firebase
import DropDown
import Toast_Swift
import GoogleMobileAds

typealias DropDownView = DropDown

/// The manager class for configuring all libraries used in app.
class LibsManager: NSObject {

    /// The default singleton instance.
    static let shared = LibsManager()

    let bannersEnabled = BehaviorRelay(value: UserDefaults.standard.bool(forKey: Configs.UserDefaultsKeys.bannersEnabled))

    private override init() {
        super.init()

        if UserDefaults.standard.object(forKey: Configs.UserDefaultsKeys.bannersEnabled) == nil {
            bannersEnabled.accept(true)
        }

        bannersEnabled.skip(1).subscribe(onNext: { (enabled) in
            UserDefaults.standard.set(enabled, forKey: Configs.UserDefaultsKeys.bannersEnabled)
            analytics.set(.adsEnabled(value: enabled))
        }).disposed(by: rx.disposeBag)
    }

    func setupLibs(with window: UIWindow? = nil) {
        let libsManager = LibsManager.shared
        libsManager.setupCocoaLumberjack()
        libsManager.setupAnalytics()
        libsManager.setupAds()
        libsManager.setupTheme()
        libsManager.setupKafkaRefresh()
        libsManager.setupFLEX()
        libsManager.setupKeyboardManager()
        libsManager.setupDropDown()
        libsManager.setupToast()
    }

    func setupTheme() {
        UIApplication.shared.theme.statusBarStyle = themeService.attribute { $0.statusBarStyle }
    }

    func setupDropDown() {
        themeService.typeStream.subscribe(onNext: { (themeType) in
            let theme = themeType.associatedObject
            DropDown.appearance().backgroundColor = theme.primary
            DropDown.appearance().selectionBackgroundColor = theme.primaryDark
            DropDown.appearance().textColor = theme.text
            DropDown.appearance().selectedTextColor = theme.text
            DropDown.appearance().separatorColor = theme.separator
        }).disposed(by: rx.disposeBag)
    }

    func setupToast() {
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.position = .top
        var style = ToastStyle()
        style.backgroundColor = UIColor.Material.red
        style.messageColor = UIColor.Material.white
        style.imageSize = CGSize(width: 20, height: 20)
        ToastManager.shared.style = style
    }

    func setupKafkaRefresh() {
        if let defaults = KafkaRefreshDefaults.standard() {
            defaults.headDefaultStyle = .replicatorAllen
            defaults.footDefaultStyle = .replicatorDot
            defaults.theme.themeColor = themeService.attribute { $0.secondary }
        }
    }

    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
    }

    func setupKingfisher() {
        // Set maximum disk cache size for default cache. Default value is 0, which means no limit.
        ImageCache.default.diskStorage.config.sizeLimit = UInt(500 * 1024 * 1024) // 500 MB

        // Set longest time duration of the cache being stored in disk. Default value is 1 week
        ImageCache.default.diskStorage.config.expiration = .days(7) // 1 week

        // Set timeout duration for default image downloader. Default value is 15 sec.
        ImageDownloader.default.downloadTimeout = 15.0 // 15 sec
    }

    func setupCocoaLumberjack() {
        DDLog.add(DDOSLogger.sharedInstance)
        let fileLogger: DDFileLogger = DDFileLogger() // File Logger
        fileLogger.rollingFrequency = TimeInterval(60*60*24)  // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }

    func setupFLEX() {
        #if DEBUG
        FLEXManager.shared.isNetworkDebuggingEnabled = true
        #endif
    }

    func setupAnalytics() {
        FirebaseApp.configure()
        Mixpanel.initialize(token: Keys.mixpanel.apiKey)
        FirebaseConfiguration.shared.setLoggerLevel(.min)
    }

    func setupAds() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}

extension LibsManager {

    func showFlex() {
        #if DEBUG
        FLEXManager.shared.showExplorer()
        analytics.log(.flexOpened)
        #endif
    }

    func removeKingfisherCache() -> Observable<Void> {
        return ImageCache.default.rx.clearCache()
    }

    func kingfisherCacheSize() -> Observable<Int> {
        return ImageCache.default.rx.retrieveCacheSize()
    }
}
