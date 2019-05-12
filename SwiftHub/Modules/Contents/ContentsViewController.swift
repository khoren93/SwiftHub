//
//  ContentsViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.contentCell.identifier

class ContentsViewController: TableViewController {

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_github(), style: .done, target: nil, action: nil)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.rightBarButtonItem = rightBarButton

        tableView.register(R.nib.contentCell)
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? ContentsViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = ContentsViewModel.Input(headerRefresh: refresh,
                                            selection: tableView.rx.modelSelected(ContentCellViewModel.self).asDriver(),
                                            openInWebSelection: rightBarButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ContentCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.openContents.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .contents(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        output.openUrl.filterNil().drive(onNext: { [weak self] (url) in
            self?.navigator.show(segue: .webController(url), sender: self, transition: .modal)
        }).disposed(by: rx.disposeBag)

        output.openSource.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .source(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
