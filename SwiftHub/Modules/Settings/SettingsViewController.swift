//
//  SettingsViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let switchReuseIdentifier = R.reuseIdentifier.settingSwitchCell.identifier
private let reuseIdentifier = R.reuseIdentifier.settingCell.identifier
private let profileReuseIdentifier = R.reuseIdentifier.userCell.identifier
private let repositoryReuseIdentifier = R.reuseIdentifier.repositoryCell.identifier

class SettingsViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.settingsNavigationTitle.key.localized()
        }).disposed(by: rx.disposeBag)

        tableView.register(R.nib.settingCell)
        tableView.register(R.nib.settingSwitchCell)
        tableView.register(R.nib.userCell)
        tableView.register(R.nib.repositoryCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? SettingsViewModel else { return }

        let refresh = Observable.of(rx.viewWillAppear.mapToVoid(), languageChanged.asObservable()).merge()
        let input = SettingsViewModel.Input(trigger: refresh,
                                            selection: tableView.rx.modelSelected(SettingsSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<SettingsSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .profileItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: profileReuseIdentifier, for: indexPath) as? UserCell)!
                cell.bind(to: viewModel)
                return cell
            case .bannerItem(let viewModel),
                 .nightModeItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: switchReuseIdentifier, for: indexPath) as? SettingSwitchCell)!
                cell.bind(to: viewModel)
                return cell
            case .themeItem(let viewModel),
                 .languageItem(let viewModel),
                 .contactsItem(let viewModel),
                 .removeCacheItem(let viewModel),
                 .acknowledgementsItem(let viewModel),
                 .whatsNewItem(let viewModel),
                 .logoutItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SettingCell)!
                cell.bind(to: viewModel)
                return cell
            case .repositoryItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: repositoryReuseIdentifier, for: indexPath) as? RepositoryCell)!
                cell.bind(to: viewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
            case .profileItem:
                if let viewModel = viewModel.viewModel(for: item) as? UserViewModel {
                    self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self, transition: .detail)
                }
            case .logoutItem:
                self?.deselectSelectedRow()
                self?.logoutAction()
            case .bannerItem,
                 .nightModeItem:
                self?.deselectSelectedRow()
            case .themeItem:
                if let viewModel = viewModel.viewModel(for: item) as? ThemeViewModel {
                    self?.navigator.show(segue: .theme(viewModel: viewModel), sender: self, transition: .detail)
                }
            case .languageItem:
                if let viewModel = viewModel.viewModel(for: item) as? LanguageViewModel {
                    self?.navigator.show(segue: .language(viewModel: viewModel), sender: self, transition: .detail)
                }
            case .contactsItem:
                if let viewModel = viewModel.viewModel(for: item) as? ContactsViewModel {
                    self?.navigator.show(segue: .contacts(viewModel: viewModel), sender: self, transition: .detail)
                }
            case .removeCacheItem:
                self?.deselectSelectedRow()
            case .acknowledgementsItem:
                self?.navigator.show(segue: .acknowledgements, sender: self, transition: .detail)
            case .whatsNewItem:
                self?.navigator.show(segue: .whatsNew(block: viewModel.whatsNewBlock()), sender: self, transition: .modal)
                analytics.log(.whatsNew)
            case .repositoryItem:
                if let viewModel = viewModel.viewModel(for: item) as? RepositoryViewModel {
                    self?.navigator.show(segue: .repositoryDetails(viewModel: viewModel), sender: self, transition: .detail)
                }
            }
        }).disposed(by: rx.disposeBag)
    }

    func logoutAction() {
        var name = ""
        if let user = User.currentUser() {
            name = user.name ?? user.login ?? ""
        }

        let alertController = UIAlertController(title: name,
                                                message: R.string.localizable.settingsLogoutAlertMessage.key.localized(),
                                                preferredStyle: UIAlertController.Style.alert)
        let logoutAction = UIAlertAction(title: R.string.localizable.settingsLogoutAlertConfirmButtonTitle.key.localized(),
                                         style: .destructive) { [weak self] (result: UIAlertAction) in
            self?.logout()
        }

        let cancelAction = UIAlertAction(title: R.string.localizable.commonCancel.key.localized(),
                                         style: .default) { (result: UIAlertAction) in
        }

        alertController.addAction(cancelAction)
        alertController.addAction(logoutAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func logout() {
        User.removeCurrentUser()
        AuthManager.removeToken()
        Application.shared.presentInitialScreen(in: Application.shared.window)

        analytics.log(.logout)
        analytics.reset()
    }
}
