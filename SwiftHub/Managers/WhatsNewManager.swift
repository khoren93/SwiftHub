//
//  WhatsNewManager.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/16/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import WhatsNewKit

typealias WhatsNewBlock = (WhatsNew, WhatsNewConfiguration, KeyValueWhatsNewVersionStore?)
typealias WhatsNewConfiguration = WhatsNewViewController.Configuration

class WhatsNewManager: NSObject {

    /// The default singleton instance.
    static let shared = WhatsNewManager()

    func whatsNew(trackVersion track: Bool = true) -> WhatsNewBlock {
        return (items(), configuration(), track ? versionStore(): nil)
    }

    private func items() -> WhatsNew {
        let whatsNew = WhatsNew(
            title: R.string.localizable.whatsNewTitle.key.localized(),
            items: [
                WhatsNew.Item(title: R.string.localizable.whatsNewItem4Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem4Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_trending()),
                WhatsNew.Item(title: R.string.localizable.whatsNewItem1Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem1Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_cloc()),
                WhatsNew.Item(title: R.string.localizable.whatsNewItem2Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem2Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_theme()),
                WhatsNew.Item(title: R.string.localizable.whatsNewItem3Title.key.localized(),
                              subtitle: R.string.localizable.whatsNewItem3Subtitle.key.localized(),
                              image: R.image.icon_whatsnew_github())
            ])
        return whatsNew
    }

    private func configuration() -> WhatsNewViewController.Configuration {
        var configuration = WhatsNewViewController.Configuration(
            detailButton: .init(title: R.string.localizable.whatsNewDetailButtonTitle.key.localized(),
                                action: .website(url: Configs.App.githubUrl)),
            completionButton: .init(stringLiteral: R.string.localizable.whatsNewCompletionButtonTitle.key.localized())
        )
        //        configuration.itemsView.layout = .centered
        configuration.itemsView.imageSize = .original
        configuration.apply(animation: .slideRight)
        if ThemeType.currentTheme().isDark {
            configuration.apply(theme: .darkRed)
            configuration.backgroundColor = .primaryDark()
        } else {
            configuration.apply(theme: .whiteRed)
            configuration.backgroundColor = .white
        }
        return configuration
    }

    private func versionStore() -> KeyValueWhatsNewVersionStore {
        let versionStore = KeyValueWhatsNewVersionStore(keyValueable: UserDefaults.standard,
                                                        prefixIdentifier: Configs.App.bundleIdentifier)
        return versionStore
    }
}
