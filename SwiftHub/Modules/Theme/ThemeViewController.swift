//
//  ThemeViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/15/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = ThemeCell.reuseID

class ThemeViewController: TableViewController {

    override func makeUI() {
        super.makeUI()

        navigationTitle = String(localized: .themeNavigationTitle)
        tableView.registerNib(ThemeCell.self)
        isHeaderRefreshEnabled = false
        isFooterRefreshEnabled = false
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? ThemeViewModel else { return }

        let input = ThemeViewModel.Input(refresh: Observable.just(()),
                                         selection: tableView.rx.modelSelected(ThemeCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.items
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ThemeCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.selected.drive(onNext: { [weak self] (cellViewModel) in
            self?.navigator.dismiss(sender: self)
        }).disposed(by: rx.disposeBag)
    }
}
