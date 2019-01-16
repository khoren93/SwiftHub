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

    let bannerEnabled: BehaviorRelay<Bool>
    let nightModeEnabled: BehaviorRelay<Bool>

    let loggedIn: BehaviorRelay<Bool>

    let whatsNewManager: WhatsNewManager

    var cellDisposeBag = DisposeBag()

    init(loggedIn: BehaviorRelay<Bool>, provider: SwiftHubAPI) {
        self.loggedIn = loggedIn
        whatsNewManager = WhatsNewManager.shared
        bannerEnabled = BehaviorRelay(value: LibsManager.shared.bannersEnabled.value)
        nightModeEnabled = BehaviorRelay(value: ThemeType.currentTheme().isDark)
        super.init(provider: provider)
        bannerEnabled.bind(to: LibsManager.shared.bannersEnabled).disposed(by: rx.disposeBag)
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[SettingsSection]>(value: [])
        let refresh = Observable.of(input.trigger, bannerEnabled.mapToVoid()).merge()
        refresh.map { [weak self] () -> [SettingsSection] in
            guard let self = self else { return [] }
            self.cellDisposeBag = DisposeBag()

            let bannerEnabled = self.bannerEnabled.value
            let bannerImageName = bannerEnabled ? R.image.icon_cell_smile.name : R.image.icon_cell_frown.name
            let bannerModel = SettingModel(leftImage: bannerImageName, title: R.string.localizable.settingsBannerTitle.key.localized(), detail: "", showDisclosure: false)
            let bannerCellViewModel = SettingSwitchCellViewModel(with: bannerModel, isEnabled: bannerEnabled)
            bannerCellViewModel.switchChanged.skip(1).bind(to: self.bannerEnabled).disposed(by: self.cellDisposeBag)

            let nightModeEnabled = self.nightModeEnabled.value
            let nightModeModel = SettingModel(leftImage: R.image.icon_cell_night_mode.name, title: R.string.localizable.settingsNightModeTitle.key.localized(), detail: "", showDisclosure: false)
            let nightModeCellViewModel = SettingSwitchCellViewModel(with: nightModeModel, isEnabled: nightModeEnabled)
            nightModeCellViewModel.switchChanged.skip(1).bind(to: self.nightModeEnabled).disposed(by: self.cellDisposeBag)

            let themeModel = SettingModel(leftImage: R.image.icon_cell_theme.name, title: R.string.localizable.settingsThemeTitle.key.localized(), detail: "", showDisclosure: true)
            let themeCellViewModel = SettingCellViewModel(with: themeModel)

            let languageModel = SettingModel(leftImage: R.image.icon_cell_language.name, title: R.string.localizable.settingsLanguageTitle.key.localized(), detail: "", showDisclosure: true)
            let languageCellViewModel = SettingCellViewModel(with: languageModel)

            let contactsModel = SettingModel(leftImage: R.image.icon_cell_company.name, title: R.string.localizable.settingsContactsTitle.key.localized(), detail: "", showDisclosure: true)
            let contactsCellViewModel = SettingCellViewModel(with: contactsModel)

            let removeCacheModel = SettingModel(leftImage: R.image.icon_cell_remove.name, title: R.string.localizable.settingsRemoveCacheTitle.key.localized(), detail: "", showDisclosure: false)
            let removeCacheCellViewModel = SettingCellViewModel(with: removeCacheModel)

            let acknowledgementsModel = SettingModel(leftImage: R.image.icon_cell_acknowledgements.name, title: R.string.localizable.settingsAcknowledgementsTitle.key.localized(), detail: "", showDisclosure: true)
            let acknowledgementsCellViewModel = SettingCellViewModel(with: acknowledgementsModel)

            let whatsNewModel = SettingModel(leftImage: R.image.icon_cell_whats_new.name, title: R.string.localizable.settingsWhatsNewTitle.key.localized(), detail: "", showDisclosure: true)
            let whatsNewCellViewModel = SettingCellViewModel(with: whatsNewModel)

            var items = [
                SettingsSection.setting(title: R.string.localizable.settingsPreferencesSectionTitle.key.localized(), items: [
                        SettingsSectionItem.bannerItem(viewModel: bannerCellViewModel),
                        SettingsSectionItem.nightModeItem(viewModel: nightModeCellViewModel),
                        SettingsSectionItem.themeItem(viewModel: themeCellViewModel),
                        SettingsSectionItem.languageItem(viewModel: languageCellViewModel),
                        SettingsSectionItem.contactsItem(viewModel: contactsCellViewModel),
                        SettingsSectionItem.removeCacheItem(viewModel: removeCacheCellViewModel)
                    ]),
                SettingsSection.setting(title: R.string.localizable.settingsSupportSectionTitle.key.localized(), items: [
                    SettingsSectionItem.acknowledgementsItem(viewModel: acknowledgementsCellViewModel),
                    SettingsSectionItem.whatsNewItem(viewModel: whatsNewCellViewModel)
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

        nightModeEnabled.skip(1).subscribe(onNext: { (isEnabled) in
            analytics.log(.appNightMode(enabled: isEnabled))
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
        case .contactsItem:
            let viewModel = ContactsViewModel(provider: self.provider)
            return viewModel
        default:
            return nil
        }
    }

    func whatsNewBlock() -> WhatsNewBlock {
        return whatsNewManager.whatsNew(trackVersion: false)
    }
}
