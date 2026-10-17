//
//  PullRequestsViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = PullRequestCell.reuseID

enum PullRequestSegments: Int {
    case open, closed

    var title: String {
        switch self {
        case .open: return String(localized: .issuesOpenSegmentTitle)
        case .closed: return String(localized: .issuesClosedSegmentTitle)
        }
    }

    var state: State {
        switch self {
        case .open: return .open
        case .closed: return .closed
        }
    }
}

class PullRequestsViewController: TableViewController {

    lazy var segmentedControl: SegmentedControl = {
        let items = [IssueSegments.open.title,
                     IssueSegments.closed.title]
        let view = SegmentedControl(sectionTitles: items)
        view.selectedSegmentIndex = 0
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(250)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl

        tableView.registerNib(PullRequestCell.self)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? PullRequestsViewModel else { return }

        let segmentSelected = Observable.of(segmentedControl.segmentSelection.map { PullRequestSegments(rawValue: $0)! }).merge()
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger, segmentSelected.mapToVoid().skip(1)).merge()
        let input = PullRequestsViewModel.Input(headerRefresh: refresh,
                                                footerRefresh: footerRefreshTrigger,
                                                segmentSelection: segmentSelected,
                                                selection: tableView.rx.modelSelected(PullRequestCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: PullRequestCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.pullRequestSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .pullRequestDetails(viewModel: viewModel), sender: self, transition: .modal)
        }).disposed(by: rx.disposeBag)

        output.userSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)
    }
}
