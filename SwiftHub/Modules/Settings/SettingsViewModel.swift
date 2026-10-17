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

    let nightModeEnabled: BehaviorRelay<Bool>

    let swiftHubRepository = BehaviorRelay<Repository?>(value: nil)
    let flutterHubRepository = BehaviorRelay<Repository?>(value: nil)
    let flutterZxingRepository = BehaviorRelay<Repository?>(value: nil)

    var cellDisposeBag = DisposeBag()

    override init(provider: SwiftHubAPI) {
        currentUser = User.currentUser()
        nightModeEnabled = BehaviorRelay(value: ThemeType.currentTheme().isDark)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[SettingsSection]>(value: [])
        let removeCache = PublishSubject<Void>()

        let cacheRemoved = removeCache.flatMapLatest { () -> Observable<Void> in
            return LibsManager.shared.removeKingfisherCache()
        }

        let refresh = Observable.of(input.trigger, cacheRemoved, swiftHubRepository.mapToVoid(), flutterHubRepository.mapToVoid(), flutterHubRepository.mapToVoid(), nightModeEnabled.mapToVoid()).merge()

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

                let logoutCellViewModel = SettingCellViewModel(with: String(localized: .settingsLogOutTitle), detail: nil,
                                                               image: UIImage(resource: .iconCellLogout).template, hidesDisclosure: true)
                accountItems.append(SettingsSectionItem.logoutItem(viewModel: logoutCellViewModel))

                items.append(SettingsSection.setting(title: String(localized: .settingsAccountSectionTitle), items: accountItems))
            }

            if let swiftHubRepository = self.swiftHubRepository.value,
                let flutterHubRepository = self.flutterHubRepository.value,
                let flutterZxingRepository = self.flutterZxingRepository.value {
                let swiftHubCellViewModel = RepositoryCellViewModel(with: swiftHubRepository)
                let flutterHubCellViewModel = RepositoryCellViewModel(with: flutterHubRepository)
                let flutterZxingCellViewModel = RepositoryCellViewModel(with: flutterZxingRepository)
                items.append(SettingsSection.setting(title: String(localized: .settingsProjectsSectionTitle), items: [
                    SettingsSectionItem.repositoryItem(viewModel: swiftHubCellViewModel),
                    SettingsSectionItem.repositoryItem(viewModel: flutterHubCellViewModel),
                    SettingsSectionItem.repositoryItem(viewModel: flutterZxingCellViewModel)
                ]))
            }

            let nightModeEnabled = self.nightModeEnabled.value
            let nightModeCellViewModel = SettingSwitchCellViewModel(with: String(localized: .settingsNightModeTitle), detail: nil,
                                                                    image: UIImage(resource: .iconCellNightMode).template, hidesDisclosure: true, isEnabled: nightModeEnabled)
            nightModeCellViewModel.switchChanged.skip(1).bind(to: self.nightModeEnabled).disposed(by: self.cellDisposeBag)

            let themeCellViewModel = SettingCellViewModel(with: String(localized: .settingsThemeTitle), detail: nil,
                                                          image: UIImage(resource: .iconCellTheme).template, hidesDisclosure: false)

            let languageCellViewModel = SettingCellViewModel(with: String(localized: .settingsLanguageTitle), detail: self.appLanguageName(),
                                                             image: UIImage(resource: .iconCellLanguage).template, hidesDisclosure: false)

            let removeCacheCellViewModel = SettingCellViewModel(with: String(localized: .settingsRemoveCacheTitle), detail: size.sizeFromByte(),
                                                                image: UIImage(resource: .iconCellRemove).template, hidesDisclosure: true)

            let acknowledgementsCellViewModel = SettingCellViewModel(with: String(localized: .settingsAcknowledgementsTitle), detail: nil,
                                                                     image: UIImage(resource: .iconCellAcknowledgements).template, hidesDisclosure: false)

            items += [
                SettingsSection.setting(title: String(localized: .settingsPreferencesSectionTitle), items: [
                    SettingsSectionItem.nightModeItem(viewModel: nightModeCellViewModel),
                    SettingsSectionItem.themeItem(viewModel: themeCellViewModel),
                    SettingsSectionItem.languageItem(viewModel: languageCellViewModel),
                    SettingsSectionItem.removeCacheItem(viewModel: removeCacheCellViewModel)
                ]),
                SettingsSection.setting(title: String(localized: .settingsSupportSectionTitle), items: [
                    SettingsSectionItem.acknowledgementsItem(viewModel: acknowledgementsCellViewModel)
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

        input.trigger.flatMapLatest { [weak self] () -> Observable<Repository> in
            guard let self = self else { return Observable.just(Repository()) }
            let fullname = "khoren93/FlutterHub"
            let qualifiedName = "main"
            return self.provider.repository(fullname: fullname, qualifiedName: qualifiedName)
                .trackActivity(self.loading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (repository) in
                self?.flutterHubRepository.accept(repository)
            }).disposed(by: rx.disposeBag)

        input.trigger.flatMapLatest { [weak self] () -> Observable<Repository> in
            guard let self = self else { return Observable.just(Repository()) }
            let fullname = "khoren93/flutter_zxing"
            let qualifiedName = "main"
            return self.provider.repository(fullname: fullname, qualifiedName: qualifiedName)
                .trackActivity(self.loading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (repository) in
                self?.flutterZxingRepository.accept(repository)
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
            analytics.set(.nightMode(value: isEnabled))
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
        case .repositoryItem(let viewModel):
            let viewModel = RepositoryViewModel(repository: viewModel.repository, provider: self.provider)
            return viewModel
        default:
            return nil
        }
    }

    /// The language the app runs in; it's changed in the system Settings
    func appLanguageName() -> String? {
        guard let code = Bundle.main.preferredLocalizations.first else { return nil }
        return Locale.current.localizedString(forIdentifier: code)?.localizedCapitalized
    }
}
