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

        navigationTitle = "Settings"
        tableView.register(R.nib.settingCell)
        tableView.register(R.nib.settingThemeCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(rx.viewWillAppear.mapToVoid()).merge()
        let input = SettingsViewModel.Input(trigger: refresh,
                                            selection: tableView.rx.modelSelected(SettingsSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<SettingsSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .settingThemeItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: themeReuseIdentifier, for: indexPath) as? SettingThemeCell)!
                cell.bind(to: viewModel)
                return cell
            case .settingItem(let viewModel):
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
            self?.tableView.deselectRow(at: (self?.tableView.indexPathForSelectedRow)!, animated: true)
            switch item {
            case .settingItem(let viewModel):
                switch viewModel.type {
                case .theme:
                    if let viewModel = viewModel.destinationViewModel as? ThemeViewModel {
                        self?.navigator.show(segue: .theme(viewModel: viewModel), sender: self, transition: .detail)
                    }
                case .language:
                    if let viewModel = viewModel.destinationViewModel as? LanguageViewModel {
                        self?.navigator.show(segue: .language(viewModel: viewModel), sender: self, transition: .detail)
                    }
                case .acknowledgements:
                    self?.navigator.show(segue: .acknowledgements, sender: self, transition: .detail)
                case .removeCache:
                    self?.clearCacheAction()
                case .logout:
                    self?.logout()
                default: break
                }
            default: break
            }
        }).disposed(by: rx.disposeBag)
    }

    func clearCacheAction() {
        LibsManager.shared.removeKingfisherCache { [weak self] in
            let alertController = UIAlertController(title: "Cache Successfully Cleared", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (result: UIAlertAction) in }
            alertController.addAction(okAction)
            self?.present(alertController, animated: true, completion: nil)
        }
    }

    func logout() {
        AuthManager.removeToken()
    }
}
