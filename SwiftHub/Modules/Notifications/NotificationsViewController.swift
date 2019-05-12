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

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_cell_check(), style: .done, target: nil, action: nil)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = rightBarButton

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.segmentedControl.sectionTitles = [NotificationSegments.unread.title,
                                                    NotificationSegments.participating.title,
                                                    NotificationSegments.all.title]
        }).disposed(by: rx.disposeBag)

        tableView.register(R.nib.notificationCell)
        tableView.headRefreshControl = nil
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

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)
        viewModel.parsedError.bind(to: error).disposed(by: rx.disposeBag)

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
            let title = R.string.localizable.commonSuccess.key.localized()
            let description = R.string.localizable.notificationsMarkAsReadSuccess.key.localized()
            let image = R.image.icon_toast_success()
            self?.tableView.makeToast(description, title: title, image: image)
        }).disposed(by: rx.disposeBag)
    }
}
