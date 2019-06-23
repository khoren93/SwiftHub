//
//  SettingsSection.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxDataSources

enum SettingsSection {
    case setting(title: String, items: [SettingsSectionItem])
}

enum SettingsSectionItem {
    // Account
    case profileItem(viewModel: UserCellViewModel)
    case logoutItem(viewModel: SettingCellViewModel)

    // My Projects
    case repositoryItem(viewModel: RepositoryCellViewModel)

    // Preferences
    case bannerItem(viewModel: SettingSwitchCellViewModel)
    case nightModeItem(viewModel: SettingSwitchCellViewModel)
    case themeItem(viewModel: SettingCellViewModel)
    case languageItem(viewModel: SettingCellViewModel)
    case contactsItem(viewModel: SettingCellViewModel)
    case removeCacheItem(viewModel: SettingCellViewModel)

    // Support
    case acknowledgementsItem(viewModel: SettingCellViewModel)
    case whatsNewItem(viewModel: SettingCellViewModel)
}

extension SettingsSectionItem: IdentifiableType {
    typealias Identity = String
    var identity: Identity {
        switch self {
        case .profileItem(let viewModel): return viewModel.user.login ?? ""
        case .repositoryItem(let viewModel): return viewModel.repository.fullname ?? ""
        case .bannerItem(let viewModel),
             .nightModeItem(let viewModel): return viewModel.title.value ?? ""
        case .logoutItem(let viewModel),
             .themeItem(let viewModel),
             .languageItem(let viewModel),
             .contactsItem(let viewModel),
             .removeCacheItem(let viewModel),
             .acknowledgementsItem(let viewModel),
             .whatsNewItem(let viewModel): return viewModel.title.value ?? ""
        }
    }
}

extension SettingsSectionItem: Equatable {
    static func == (lhs: SettingsSectionItem, rhs: SettingsSectionItem) -> Bool {
        return lhs.identity == rhs.identity
    }
}

extension SettingsSection: AnimatableSectionModelType, IdentifiableType {
    typealias Item = SettingsSectionItem

    typealias Identity = String
    var identity: Identity { return title }

    var title: String {
        switch self {
        case .setting(let title, _): return title
        }
    }

    var items: [SettingsSectionItem] {
        switch  self {
        case .setting(_, let items): return items.map {$0}
        }
    }

    init(original: SettingsSection, items: [Item]) {
        switch original {
        case .setting(let title, let items): self = .setting(title: title, items: items)
        }
    }
}
