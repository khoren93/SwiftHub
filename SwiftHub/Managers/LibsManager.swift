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
import FLEX
import Fabric
import Crashlytics
import NVActivityIndicatorView
import NSObject_Rx
import RxViewController
import RxOptional
import RxGesture
import SwifterSwift
import SwiftDate
import Hero
import KafkaRefresh
import Umbrella
import Mixpanel
import Firebase
import DropDown
import Toast_Swift

typealias DropDownView = DropDown

/// The manager class for configuring all libraries used in app.
class LibsManager: NSObject {

    /// The default singleton instance.
    static let shared = LibsManager()

    let bannersEnabled = BehaviorRelay(value: UserDefaults.standard.bool(forKey: Configs.UserDefaultsKeys.bannersEnabled))

    override init() {
        super.init()

        if UserDefaults.standard.object(forKey: Configs.UserDefaultsKeys.bannersEnabled) == nil {
            bannersEnabled.accept(true)
        }

        bannersEnabled.subscribe(onNext: { (enabled) in
            UserDefaults.standard.set(enabled, forKey: Configs.UserDefaultsKeys.bannersEnabled)
            analytics.updateUser(ads: enabled)
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
        libsManager.setupActivityView()
        libsManager.setupDropDown()
        libsManager.setupToast()
    }

    func setupTheme() {
        themeService.rx
            .bind({ $0.statusBarStyle }, to: UIApplication.shared.rx.statusBarStyle)
            .disposed(by: rx.disposeBag)
    }

    func setupDropDown() {
        themeService.attrsStream.subscribe(onNext: { (theme) in
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
            themeService.rx
                .bind({ $0.secondary }, to: defaults.rx.themeColor)
                .disposed(by: rx.disposeBag)
        }
    }

    func setupActivityView() {
        NVActivityIndicatorView.DEFAULT_TYPE = .ballRotateChase
        NVActivityIndicatorView.DEFAULT_COLOR = .secondary()
    }

    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = false
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
        FLEXManager.shared.isNetworkDebuggingEnabled = true
    }

    func setupAnalytics() {
        FirebaseApp.configure()
        Mixpanel.sharedInstance(withToken: Keys.mixpanel.apiKey)
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = false
        analytics.register(provider: MixpanelProvider())
        analytics.register(provider: FirebaseProvider())
    }

    func setupAds() {
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
}

extension LibsManager {

    func showFlex() {
        FLEXManager.shared.showExplorer()
        analytics.log(.flexOpened)
    }

    func removeKingfisherCache() -> Observable<Void> {
        return ImageCache.default.rx.clearCache()
    }

    func kingfisherCacheSize() -> Observable<Int> {
        return ImageCache.default.rx.retrieveCacheSize()
    }
}
