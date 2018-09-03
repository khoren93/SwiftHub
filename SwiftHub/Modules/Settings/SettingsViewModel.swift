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
            let isNightMode = ThemeType.currentTheme() == ThemeType.dark
            let themeModel = SettingModel(type: .nightMode, leftImage: R.image.icon_cell_night_mode.name, title: "Night Mode", detail: "", showDisclosure: false)
            let themeCellViewModel = SettingThemeCellViewModel(with: themeModel, isEnabled: isNightMode, destinationViewModel: nil)
            themeCellViewModel.nightModeEnabled.bind(to: self.nightModeEnabled).disposed(by: self.rx.disposeBag)

            let removeCacheModel = SettingModel(type: .removeCache, leftImage: R.image.icon_cell_remove.name, title: "Remove Cache", detail: "", showDisclosure: false)
            let removeCacheCellViewModel = SettingCellViewModel(with: removeCacheModel, destinationViewModel: nil)

            let acknowledgementsModel = SettingModel(type: .acknowledgements, leftImage: R.image.icon_cell_acknowledgements.name, title: "Acknowledgements", detail: "", showDisclosure: true)
            let acknowledgementsCellViewModel = SettingCellViewModel(with: acknowledgementsModel, destinationViewModel: nil)

            var items = [
                SettingsSection.setting(title: "Preferences", items: [
                        SettingsSectionItem.settingThemeItem(viewModel: themeCellViewModel),
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
            let theme = isEnabled ? ThemeType.dark : ThemeType.light
            theme.save()
            themeService.set(theme)
        }).disposed(by: rx.disposeBag)

        return Output(items: elements,
                      selectedEvent: selectedEvent)
    }
}
