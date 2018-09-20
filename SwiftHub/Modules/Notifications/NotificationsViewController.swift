//
//  NotificationsViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 9/19/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.notificationCell.identifier

enum NotificationSegments: Int {
    case unread, participating, all

    var title: String {
        switch self {
        case .unread: return "Unread"
        case .participating: return "Participating"
        case .all: return "All"
        }
    }
}

class NotificationsViewController: TableViewController {

    var viewModel: NotificationsViewModel!

    lazy var segmentedControl: SegmentedControl = {
        let items = [NotificationSegments.unread.title,
                     NotificationSegments.participating.title,
                     NotificationSegments.all.title]
        let view = SegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl

        emptyDataSetTitle = "No new Notifications"

        tableView.register(R.nib.notificationCell)
        tableView.headRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let segmentSelected = Observable.of(segmentedControl.rx.selectedSegmentIndex.map { NotificationSegments(rawValue: $0)! }).merge()
        let input = NotificationsViewModel.Input(headerRefresh: Observable.just(()),
                                                 footerRefresh: footerRefreshTrigger,
                                                 segmentSelection: segmentSelected,
                                                 selection: tableView.rx.modelSelected(NotificationCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.fetching.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        output.footerFetching.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: NotificationCell.self)) { tableView, viewModel, cell in
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
