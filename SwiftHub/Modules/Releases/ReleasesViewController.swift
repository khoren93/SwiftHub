//
//  ReleasesViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/12/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.releaseCell.identifier

class ReleasesViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        tableView.register(R.nib.releaseCell)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? ReleasesViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = ReleasesViewModel.Input(headerRefresh: refresh,
                                            footerRefresh: footerRefreshTrigger,
                                            selection: tableView.rx.modelSelected(ReleaseCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ReleaseCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.releaseSelected.drive(onNext: { [weak self] (url) in
            self?.navigator.show(segue: .webController(url), sender: self)
        }).disposed(by: rx.disposeBag)

        output.userSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
