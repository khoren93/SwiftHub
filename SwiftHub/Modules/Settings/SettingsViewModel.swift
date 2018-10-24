//
//  SettingsViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class SettingsViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Observable<Void>
        let selection: Driver<SettingsSectionItem>
    }

    struct Output {
        let items: BehaviorRelay<[SettingsSection]>
        let selectedEvent: Driver<SettingsSectionItem>
    }

    let nightModeEnabled = PublishSubject<Bool>()

    let loggedIn: BehaviorRelay<Bool>

    init(loggedIn: BehaviorRelay<Bool>, provider: SwiftHubAPI) {
        self.loggedIn = loggedIn
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[SettingsSection]>(value: [])
        input.trigger.map { () -> [SettingsSection] in
            let isNightMode = ThemeType.currentTheme().isDark
            let nightModeModel = SettingModel(leftImage: R.image.icon_cell_night_mode.name, title: R.string.localizable.settingsNightModeTitle.key.localized(), detail: "", showDisclosure: false)
            let nightModeCellViewModel = SettingThemeCellViewModel(with: nightModeModel, isEnabled: isNightMode)
            nightModeCellViewModel.nightModeEnabled.bind(to: self.nightModeEnabled).disposed(by: self.rx.disposeBag)

            let themeModel = SettingModel(leftImage: R.image.icon_cell_theme.name, title: R.string.localizable.settingsThemeTitle.key.localized(), detail: "", showDisclosure: true)
            let themeCellViewModel = SettingCellViewModel(with: themeModel)

            let languageModel = SettingModel(leftImage: R.image.icon_cell_language.name, title: R.string.localizable.settingsLanguageTitle.key.localized(), detail: "", showDisclosure: true)
            let languageCellViewModel = SettingCellViewModel(with: languageModel)

            let removeCacheModel = SettingModel(leftImage: R.image.icon_cell_remove.name, title: R.string.localizable.settingsRemoveCacheTitle.key.localized(), detail: "", showDisclosure: false)
            let removeCacheCellViewModel = SettingCellViewModel(with: removeCacheModel)

            let acknowledgementsModel = SettingModel(leftImage: R.image.icon_cell_acknowledgements.name, title: R.string.localizable.settingsAcknowledgementsTitle.key.localized(), detail: "", showDisclosure: true)
            let acknowledgementsCellViewModel = SettingCellViewModel(with: acknowledgementsModel)

            var items = [
                SettingsSection.setting(title: R.string.localizable.settingsPreferencesSectionTitle.key.localized(), items: [
                        SettingsSectionItem.nightModeItem(viewModel: nightModeCellViewModel),
                        SettingsSectionItem.themeItem(viewModel: themeCellViewModel),
                        SettingsSectionItem.languageItem(viewModel: languageCellViewModel),
                        SettingsSectionItem.removeCacheItem(viewModel: removeCacheCellViewModel)
                    ]),
                SettingsSection.setting(title: R.string.localizable.settingsSupportSectionTitle.key.localized(), items: [
                    SettingsSectionItem.acknowledgementsItem(viewModel: acknowledgementsCellViewModel)
                    ])
            ]

            if self.loggedIn.value {
                let logoutModel = SettingModel(leftImage: R.image.icon_cell_logout.name, title: R.string.localizable.settingsLogOutTitle.key.localized(), detail: "", showDisclosure: false)
                let logoutCellViewModel = SettingCellViewModel(with: logoutModel)
                items.append(SettingsSection.setting(title: "", items: [
                    SettingsSectionItem.logoutItem(viewModel: logoutCellViewModel)
                    ]))
            }

            return items
        }.bind(to: elements).disposed(by: rx.disposeBag)

        let selectedEvent = input.selection

        nightModeEnabled.subscribe(onNext: { (isEnabled) in
            var theme = ThemeType.currentTheme()
            if theme.isDark != isEnabled {
                theme = theme.toggled()
            }
            themeService.set(theme)
        }).disposed(by: rx.disposeBag)

        return Output(items: elements,
                      selectedEvent: selectedEvent)
    }

    func viewModel(for item: SettingsSectionItem) -> ViewModel? {
        switch item {
        case .themeItem:
            let viewModel = ThemeViewModel(provider: self.provider)
            return viewModel
        case .languageItem:
            let viewModel = LanguageViewModel(provider: self.provider)
            return viewModel
        default:
            return nil
        }
    }
}
