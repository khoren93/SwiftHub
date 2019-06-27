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

    let currentUser: User?

    let bannerEnabled: BehaviorRelay<Bool>
    let nightModeEnabled: BehaviorRelay<Bool>

    let whatsNewManager: WhatsNewManager

    let swiftHubRepository = BehaviorRelay<Repository?>(value: nil)

    var cellDisposeBag = DisposeBag()

    override init(provider: SwiftHubAPI) {
        currentUser = User.currentUser()
        whatsNewManager = WhatsNewManager.shared
        bannerEnabled = BehaviorRelay(value: LibsManager.shared.bannersEnabled.value)
        nightModeEnabled = BehaviorRelay(value: ThemeType.currentTheme().isDark)
        super.init(provider: provider)
        bannerEnabled.bind(to: LibsManager.shared.bannersEnabled).disposed(by: rx.disposeBag)
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[SettingsSection]>(value: [])
        let removeCache = PublishSubject<Void>()

        let cacheRemoved = removeCache.flatMapLatest { () -> Observable<Void> in
            return LibsManager.shared.removeKingfisherCache()
        }

        let refresh = Observable.of(input.trigger, cacheRemoved, swiftHubRepository.mapToVoid(),
                                    bannerEnabled.mapToVoid(), nightModeEnabled.mapToVoid()).merge()

        let cacheSize = refresh.flatMapLatest { () -> Observable<Int> in
            return LibsManager.shared.kingfisherCacheSize()
        }

        Observable.combineLatest(refresh, cacheSize).map { [weak self] (_, size) -> [SettingsSection] in
            guard let self = self else { return [] }
            self.cellDisposeBag = DisposeBag()
            var items: [SettingsSection] = []

            if loggedIn.value {
                var accountItems: [SettingsSectionItem] = []
                if let user = self.currentUser {
                    let profileCellViewModel = UserCellViewModel(with: user)
                    accountItems.append(SettingsSectionItem.profileItem(viewModel: profileCellViewModel))
                }

                let logoutCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsLogOutTitle.key.localized(), detail: nil,
                                                               image: R.image.icon_cell_logout()?.template, hidesDisclosure: true)
                accountItems.append(SettingsSectionItem.logoutItem(viewModel: logoutCellViewModel))

                items.append(SettingsSection.setting(title: R.string.localizable.settingsAccountSectionTitle.key.localized(), items: accountItems))
            }

            if let swiftHubRepository = self.swiftHubRepository.value {
                let swiftHubCellViewModel = RepositoryCellViewModel(with: swiftHubRepository)
                items.append(SettingsSection.setting(title: R.string.localizable.settingsProjectsSectionTitle.key.localized(), items: [
                    SettingsSectionItem.repositoryItem(viewModel: swiftHubCellViewModel)
                ]))
            }

            let bannerEnabled = self.bannerEnabled.value
            let bannerImage = bannerEnabled ? R.image.icon_cell_smile()?.template : R.image.icon_cell_frown()?.template
            let bannerCellViewModel = SettingSwitchCellViewModel(with: R.string.localizable.settingsBannerTitle.key.localized(), detail: nil,
                                                                 image: bannerImage, hidesDisclosure: true, isEnabled: bannerEnabled)
            bannerCellViewModel.switchChanged.skip(1).bind(to: self.bannerEnabled).disposed(by: self.cellDisposeBag)

            let nightModeEnabled = self.nightModeEnabled.value
            let nightModeCellViewModel = SettingSwitchCellViewModel(with: R.string.localizable.settingsNightModeTitle.key.localized(), detail: nil,
                                                                    image: R.image.icon_cell_night_mode()?.template, hidesDisclosure: true, isEnabled: nightModeEnabled)
            nightModeCellViewModel.switchChanged.skip(1).bind(to: self.nightModeEnabled).disposed(by: self.cellDisposeBag)

            let themeCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsThemeTitle.key.localized(), detail: nil,
                                                          image: R.image.icon_cell_theme()?.template, hidesDisclosure: false)

            let languageCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsLanguageTitle.key.localized(), detail: nil,
                                                             image: R.image.icon_cell_language()?.template, hidesDisclosure: false)

            let contactsCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsContactsTitle.key.localized(), detail: nil,
                                                             image: R.image.icon_cell_company()?.template, hidesDisclosure: false)

            let removeCacheCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsRemoveCacheTitle.key.localized(), detail: size.sizeFromByte(),
                                                                image: R.image.icon_cell_remove()?.template, hidesDisclosure: true)

            let acknowledgementsCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsAcknowledgementsTitle.key.localized(), detail: nil,
                                                                     image: R.image.icon_cell_acknowledgements()?.template, hidesDisclosure: false)

            let whatsNewCellViewModel = SettingCellViewModel(with: R.string.localizable.settingsWhatsNewTitle.key.localized(), detail: nil,
                                                             image: R.image.icon_cell_whats_new()?.template, hidesDisclosure: false)

            items += [
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

            return items
        }.bind(to: elements).disposed(by: rx.disposeBag)

        input.trigger.flatMapLatest { [weak self] () -> Observable<Repository> in
            guard let self = self else { return Observable.just(Repository()) }
            let fullname = "khoren93/SwiftHub"
            let qualifiedName = "master"
            return self.provider.repository(fullname: fullname, qualifiedName: qualifiedName)
                .trackActivity(self.loading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (repository) in
                self?.swiftHubRepository.accept(repository)
            }).disposed(by: rx.disposeBag)

        let selectedEvent = input.selection

        selectedEvent.asObservable().subscribe(onNext: { (item) in
            switch item {
            case .removeCacheItem: removeCache.onNext(())
            default: break
            }
        }).disposed(by: rx.disposeBag)

        nightModeEnabled.subscribe(onNext: { (isEnabled) in
            var theme = ThemeType.currentTheme()
            if theme.isDark != isEnabled {
                theme = theme.toggled()
            }
            themeService.switch(theme)
        }).disposed(by: rx.disposeBag)

        nightModeEnabled.skip(1).subscribe(onNext: { (isEnabled) in
            analytics.log(.appNightMode(enabled: isEnabled))
            analytics.updateUser(nightMode: isEnabled)
        }).disposed(by: rx.disposeBag)

        bannerEnabled.skip(1).subscribe(onNext: { (isEnabled) in
            analytics.log(.appAds(enabled: isEnabled))
        }).disposed(by: rx.disposeBag)

        cacheRemoved.subscribe(onNext: { () in
            analytics.log(.appCacheRemoved)
        }).disposed(by: rx.disposeBag)

        return Output(items: elements,
                      selectedEvent: selectedEvent)
    }

    func viewModel(for item: SettingsSectionItem) -> ViewModel? {
        switch item {
        case .profileItem:
            let viewModel = UserViewModel(user: currentUser ?? User(), provider: provider)
            return viewModel
        case .themeItem:
            let viewModel = ThemeViewModel(provider: self.provider)
            return viewModel
        case .languageItem:
            let viewModel = LanguageViewModel(provider: self.provider)
            return viewModel
        case .contactsItem:
            let viewModel = ContactsViewModel(provider: self.provider)
            return viewModel
        case .repositoryItem(let viewModel):
            let viewModel = RepositoryViewModel(repository: viewModel.repository, provider: self.provider)
            return viewModel
        default:
            return nil
        }
    }

    func whatsNewBlock() -> WhatsNewBlock {
        return whatsNewManager.whatsNew(trackVersion: false)
    }
}
