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

private let themeReuseIdentifier = R.reuseIdentifier.settingThemeCell.identifier
private let reuseIdentifier = R.reuseIdentifier.settingCell.identifier

class SettingsViewController: TableViewController {

    var viewModel: SettingsViewModel!

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
        tableView.register(R.nib.settingThemeCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(rx.viewDidLoad.mapToVoid(),
                                    languageChanged.asObservable()).merge()
        let input = SettingsViewModel.Input(trigger: refresh,
                                            selection: tableView.rx.modelSelected(SettingsSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<SettingsSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .nightModeItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: themeReuseIdentifier, for: indexPath) as? SettingThemeCell)!
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
            case .nightModeItem:
                self?.deselectSelectedRow()
            case .themeItem:
                if let viewModel = self?.viewModel.viewModel(for: item) as? ThemeViewModel {
                    self?.navigator.show(segue: .theme(viewModel: viewModel), sender: self, transition: .detail)
                }
            case .languageItem:
                if let viewModel = self?.viewModel.viewModel(for: item) as? LanguageViewModel {
                    self?.navigator.show(segue: .language(viewModel: viewModel), sender: self, transition: .detail)
                }
            case .removeCacheItem:
                self?.deselectSelectedRow()
                self?.clearCacheAction()
            case .acknowledgementsItem:
                self?.navigator.show(segue: .acknowledgements, sender: self, transition: .detail)
            case .logoutItem:
                self?.deselectSelectedRow()
                self?.logout()
            }
        }).disposed(by: rx.disposeBag)
    }

    func clearCacheAction() {
        LibsManager.shared.removeKingfisherCache { [weak self] in
            let alertController = UIAlertController(title: R.string.localizable.settingsRemoveCacheAlertSuccessMessage.key.localized(),
                                                    message: nil, preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: R.string.localizable.commonOK.key.localized(), style: .default) { (result: UIAlertAction) in }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }

    func logout() {
        AuthManager.removeToken()
    }
}
