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
            let nightModeModel = SettingModel(type: .nightMode, leftImage: R.image.icon_cell_night_mode.name, title: "Night Mode", detail: "", showDisclosure: false)
            let nightModeCellViewModel = SettingThemeCellViewModel(with: nightModeModel, isEnabled: isNightMode, destinationViewModel: nil)
            nightModeCellViewModel.nightModeEnabled.bind(to: self.nightModeEnabled).disposed(by: self.rx.disposeBag)

            let themeModel = SettingModel(type: .theme, leftImage: R.image.icon_cell_theme.name, title: "Theme", detail: "", showDisclosure: true)
            let themeViewModel = ThemeViewModel(provider: self.provider)
            let themeCellViewModel = SettingCellViewModel(with: themeModel, destinationViewModel: themeViewModel)

            let languageModel = SettingModel(type: .language, leftImage: R.image.icon_cell_language.name, title: "Language", detail: "", showDisclosure: true)
            let languageViewModel = LanguageViewModel(provider: self.provider)
            let languageCellViewModel = SettingCellViewModel(with: languageModel, destinationViewModel: languageViewModel)

            let removeCacheModel = SettingModel(type: .removeCache, leftImage: R.image.icon_cell_remove.name, title: "Remove Cache", detail: "", showDisclosure: false)
            let removeCacheCellViewModel = SettingCellViewModel(with: removeCacheModel, destinationViewModel: nil)

            let acknowledgementsModel = SettingModel(type: .acknowledgements, leftImage: R.image.icon_cell_acknowledgements.name, title: "Acknowledgements", detail: "", showDisclosure: true)
            let acknowledgementsCellViewModel = SettingCellViewModel(with: acknowledgementsModel, destinationViewModel: nil)

            var items = [
                SettingsSection.setting(title: "Preferences", items: [
                        SettingsSectionItem.settingThemeItem(viewModel: nightModeCellViewModel),
                        SettingsSectionItem.settingItem(viewModel: themeCellViewModel),
                        SettingsSectionItem.settingItem(viewModel: languageCellViewModel),
                        SettingsSectionItem.settingItem(viewModel: removeCacheCellViewModel)
                    ]),
                SettingsSection.setting(title: "Support", items: [
                    SettingsSectionItem.settingItem(viewModel: acknowledgementsCellViewModel)
                    ])
            ]

            if self.loggedIn.value {
                let logoutModel = SettingModel(type: .logout, leftImage: R.image.icon_cell_logout.name, title: "Logout", detail: "", showDisclosure: false)
                let logoutCellViewModel = SettingCellViewModel(with: logoutModel, destinationViewModel: nil)
                items.append(SettingsSection.setting(title: "", items: [
                    SettingsSectionItem.settingItem(viewModel: logoutCellViewModel)
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
}
