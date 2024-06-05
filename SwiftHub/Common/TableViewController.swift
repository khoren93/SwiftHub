//
//  TableViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import KafkaRefresh

class TableViewController: ViewController, UIScrollViewDelegate {

    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)

    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()

    var clearsSelectionOnViewWillAppear = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if clearsSelectionOnViewWillAppear == true {
            deselectSelectedRow()
        }
    }

    override func makeUI() {
        super.makeUI()

        stackView.spacing = 0
        stackView.insertArrangedSubview(tableView, at: 0)

        tableView.bindGlobalStyle(forHeadRefreshHandler: { [weak self] in
            self?.headerRefreshTrigger.onNext(())
        })

        tableView.bindGlobalStyle(forFootRefreshHandler: { [weak self] in
            self?.footerRefreshTrigger.onNext(())
        })

        isHeaderLoading.bind(to: tableView.headRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)
        isFooterLoading.bind(to: tableView.footRefreshControl.rx.isAnimating).disposed(by: rx.disposeBag)

        tableView.footRefreshControl.autoRefreshOnFoot = true

        error.subscribe(onNext: { [weak self] (error) in
            self?.tableView.makeToast(error.description, title: error.title, image: R.image.icon_toast_warning())
        }).disposed(by: rx.disposeBag)
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel?.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel?.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        let updateEmptyDataSet = Observable.of(isLoading.mapToVoid().asObservable(), emptyDataSetImageTintColor.mapToVoid(), languageChanged.asObservable()).merge()
        updateEmptyDataSet.subscribe(onNext: { [weak self] () in
            self?.tableView.reloadEmptyDataSet()
        }).disposed(by: rx.disposeBag)
    }
}

extension TableViewController {

    func deselectSelectedRow() {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows {
            selectedIndexPaths.forEach({ (indexPath) in
                tableView.deselectRow(at: indexPath, animated: false)
            })
        }
    }
}

extension TableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView, let textLabel = view.textLabel {
            textLabel.font = UIFont.systemFont(ofSize: 15)
            textLabel.theme.textColor = themeService.attribute { $0.text }
            view.contentView.theme.backgroundColor = themeService.attribute { $0.primaryDark }
        }
    }
}
