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
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = SettingsViewModel.Input(trigger: Driver.just(()),
                                            selection: tableView.rx.modelSelected(SettingCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<SectionType<SettingCellViewModel>>(configureCell: { dataSource, tableView, indexPath, viewModel in
            let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? SettingCell)!
            cell.bind(to: viewModel)
            return cell
        }, titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        })

        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        output.selectedEvent.drive(onNext: { [weak self] (viewModel) in
                self?.tableView.deselectRow(at: (self?.tableView.indexPathForSelectedRow)!, animated: true)
                switch viewModel.type {
                case .acknowledgements: break
//                    if let viewModel = viewModel.destinationViewModel as? ContactsViewModel {
//                        self?.navigator.show(segue: .contacts(viewModel: viewModel), sender: self)
//                    }
                case .removeCache: self?.clearCacheAction()
                }
        }).disposed(by: rx.disposeBag)
    }

    func clearCacheAction() {
        LibsManager.shared.removeKingfisherCache {
            let alertController = UIAlertController(title: "Cache Successfully Cleared", message: nil, preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: .default) { (result: UIAlertAction) in }
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
