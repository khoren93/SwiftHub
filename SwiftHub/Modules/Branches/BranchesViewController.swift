//
//  BranchesViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/6/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.branchCell.identifier

class BranchesViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        tableView.register(R.nib.branchCell)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? BranchesViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = BranchesViewModel.Input(headerRefresh: refresh,
                                            footerRefresh: footerRefreshTrigger,
                                            selection: tableView.rx.modelSelected(BranchCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: BranchCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        viewModel.branchSelected.subscribe(onNext: { [weak self] (branch) in
            self?.navigator.pop(sender: self)
        }).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
