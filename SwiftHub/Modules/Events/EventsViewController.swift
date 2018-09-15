//
//  EventsViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.eventCell.identifier

class EventsViewController: TableViewController {

    var viewModel: EventsViewModel!

    lazy var ownerImageView: SlideImageView = {
        let view = SlideImageView()
        view.cornerRadius = 40
        return view
    }()

    lazy var headerView: View = {
        let view = View()
        view.hero.id = "TopHeaderId"
        view.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(self.inset)
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(80)
        })
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        themeService.rx
            .bind({ $0.primaryDark }, to: headerView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)

        stackView.insertArrangedSubview(headerView, at: 0)

        tableView.register(R.nib.eventCell)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = EventsViewModel.Input(headerRefresh: refresh,
                                         footerRefresh: footerRefreshTrigger,
                                         selection: tableView.rx.modelSelected(EventCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.fetching.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        output.headerFetching.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        output.footerFetching.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: EventCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.userSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.repositorySelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .repositoryDetails(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.error.drive(onNext: { [weak self] (error) in
            self?.showAlert(title: "Error", message: error.localizedDescription)
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }
}
