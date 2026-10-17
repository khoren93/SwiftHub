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

private let switchReuseIdentifier = SettingSwitchCell.reuseID
private let reuseIdentifier = SettingCell.reuseID
private let profileReuseIdentifier = UserCell.reuseID
private let repositoryReuseIdentifier = RepositoryCell.reuseID

class SettingsViewController: TableViewController {

    override func makeUI() {
        super.makeUI()

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = String(localized: .settingsNavigationTitle)
        }).disposed(by: rx.disposeBag)

        tableView.registerNib(SettingCell.self)
        tableView.registerNib(SettingSwitchCell.self)
        tableView.registerNib(UserCell.self)
        tableView.registerNib(RepositoryCell.self)
        isHeaderRefreshEnabled = false
        isFooterRefreshEnabled = false
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
            case .nightModeItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: switchReuseIdentifier, for: indexPath) as? SettingSwitchCell)!
                cell.bind(to: viewModel)
                return cell
            case .themeItem(let viewModel),
                 .languageItem(let viewModel),
                 .removeCacheItem(let viewModel),
                 .acknowledgementsItem(let viewModel),
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
            case .nightModeItem:
                self?.deselectSelectedRow()
            case .themeItem:
                if let viewModel = viewModel.viewModel(for: item) as? ThemeViewModel {
                    self?.navigator.show(segue: .theme(viewModel: viewModel), sender: self, transition: .detail)
                }
            case .languageItem:
                self?.deselectSelectedRow()
                // Per-app language is chosen in the system Settings
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    self?.navigator.show(segue: .safari(url), sender: self)
                }
            case .removeCacheItem:
                self?.deselectSelectedRow()
            case .acknowledgementsItem:
                self?.navigator.show(segue: .acknowledgements, sender: self, transition: .detail)
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
                                                message: String(localized: .settingsLogoutAlertMessage),
                                                preferredStyle: UIAlertController.Style.alert)
        let logoutAction = UIAlertAction(title: String(localized: .settingsLogoutAlertConfirmButtonTitle),
                                         style: .destructive) { [weak self] (result: UIAlertAction) in
            self?.logout()
        }

        let cancelAction = UIAlertAction(title: String(localized: .commonCancel),
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
