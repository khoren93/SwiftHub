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
        case .unread: return R.string.localizable.notificationsUnreadSegmentTitle.key.localized()
        case .participating: return R.string.localizable.notificationsParticipatingSegmentTitle.key.localized()
        case .all: return R.string.localizable.notificationsAllSegmentTitle.key.localized()
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

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.segmentedControl.setTitle(NotificationSegments.unread.title, forSegmentAt: 0)
            self?.segmentedControl.setTitle(NotificationSegments.participating.title, forSegmentAt: 1)
            self?.segmentedControl.setTitle(NotificationSegments.all.title, forSegmentAt: 2)
        }).disposed(by: rx.disposeBag)

        tableView.register(R.nib.notificationCell)
        tableView.headRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let segmentSelected = Observable.of(segmentedControl.rx.selectedSegmentIndex.map { NotificationSegments(rawValue: $0)! }).merge()
        let refresh = Observable.of(Observable.just(()), segmentSelected.mapToVoid()).merge()
        let input = NotificationsViewModel.Input(headerRefresh: refresh,
                                                 footerRefresh: footerRefreshTrigger,
                                                 segmentSelection: segmentSelected,
                                                 selection: tableView.rx.modelSelected(NotificationCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

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

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
