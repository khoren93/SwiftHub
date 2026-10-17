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

private let reuseIdentifier = NotificationCell.reuseID

enum NotificationSegments: Int {
    case unread, participating, all

    var title: String {
        switch self {
        case .unread: return String(localized: .notificationsUnreadSegmentTitle)
        case .participating: return String(localized: .notificationsParticipatingSegmentTitle)
        case .all: return String(localized: .notificationsAllSegmentTitle)
        }
    }
}

class NotificationsViewController: TableViewController {

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: UIImage(resource: .iconCellCheck), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var segmentedControl: SegmentedControl = {
        let items = [NotificationSegments.unread.title,
                     NotificationSegments.participating.title,
                     NotificationSegments.all.title]
        let view = SegmentedControl(sectionTitles: items)
        view.selectedSegmentIndex = 0
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(260)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = rightBarButton

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.segmentedControl.sectionTitles = [NotificationSegments.unread.title,
                                                    NotificationSegments.participating.title,
                                                    NotificationSegments.all.title]
        }).disposed(by: rx.disposeBag)

        tableView.registerNib(NotificationCell.self)
        isHeaderRefreshEnabled = false
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? NotificationsViewModel else { return }

        let segmentSelected = Observable.of(segmentedControl.segmentSelection.map { NotificationSegments(rawValue: $0)! }).merge()
        let refresh = Observable.of(Observable.just(()), segmentSelected.mapToVoid()).merge()
        let input = NotificationsViewModel.Input(headerRefresh: refresh,
                                                 footerRefresh: footerRefreshTrigger,
                                                 segmentSelection: segmentSelected,
                                                 markAsReadSelection: rightBarButton.rx.tap.asObservable(),
                                                 selection: tableView.rx.modelSelected(NotificationCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

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

        output.markAsReadSelected.drive(onNext: { [weak self] () in
            let title = String(localized: .commonSuccess)
            let description = String(localized: .notificationsMarkAsReadSuccess)
            let image = UIImage(resource: .iconToastSuccess)
            self?.tableView.makeToast(description, title: title, image: image)
        }).disposed(by: rx.disposeBag)
    }
}
