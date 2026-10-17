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

class TableViewController: ViewController, UIScrollViewDelegate {

    let headerRefreshTrigger = PublishSubject<Void>()
    let footerRefreshTrigger = PublishSubject<Void>()

    let isHeaderLoading = BehaviorRelay(value: false)
    let isFooterLoading = BehaviorRelay(value: false)

    /// Pull to refresh
    var isHeaderRefreshEnabled = true {
        didSet { tableView.refreshControl = isHeaderRefreshEnabled ? headerRefreshControl : nil }
    }

    /// Load the next page when the last row is displayed
    var isFooterRefreshEnabled = true

    lazy var tableView: TableView = {
        let view = TableView(frame: CGRect(), style: .plain)
        view.backgroundView = self.emptyDataSetView
        view.rowsChanged = { [weak self] isEmpty in
            self?.reloadEmptyDataSet(isEmpty: isEmpty)
        }
        view.rx.setDelegate(self).disposed(by: rx.disposeBag)
        return view
    }()

    lazy var headerRefreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.theme.tintColor = themeService.attribute { $0.secondary }
        return view
    }()

    lazy var footerActivityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.frame = CGRect(x: 0, y: 0, width: 0, height: 50)
        themeService.typeStream.subscribe(onNext: { [weak view] (themeType) in
            view?.color = themeType.associatedObject.secondary
        }).disposed(by: rx.disposeBag)
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

        tableView.refreshControl = headerRefreshControl
        headerRefreshControl.rx.controlEvent(.valueChanged)
            .bind(to: headerRefreshTrigger)
            .disposed(by: rx.disposeBag)

        isHeaderLoading.filter { !$0 }.subscribe(onNext: { [weak self] _ in
            self?.headerRefreshControl.endRefreshing()
        }).disposed(by: rx.disposeBag)

        isFooterLoading.subscribe(onNext: { [weak self] isLoading in
            guard let self = self else { return }
            if isLoading {
                self.footerActivityIndicator.startAnimating()
                self.tableView.tableFooterView = self.footerActivityIndicator
            } else {
                self.footerActivityIndicator.stopAnimating()
                self.tableView.tableFooterView = UIView()
            }
        }).disposed(by: rx.disposeBag)

        error.subscribe(onNext: { [weak self] (error) in
            self?.tableView.makeToast(error.description, title: error.title, image: UIImage(resource: .iconToastWarning))
        }).disposed(by: rx.disposeBag)
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel?.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel?.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        let updateEmptyDataSet = Observable.of(isLoading.mapToVoid().asObservable(), emptyDataSetImageTintColor.mapToVoid(), languageChanged.asObservable()).merge()
        updateEmptyDataSet.subscribe(onNext: { [weak self] () in
            guard let self = self else { return }
            self.reloadEmptyDataSet(isEmpty: self.tableView.isEmpty)
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

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastSection = tableView.numberOfSections - 1
        guard isFooterRefreshEnabled, !isHeaderLoading.value, !isFooterLoading.value,
              indexPath.section == lastSection,
              indexPath.row == tableView.numberOfRows(inSection: lastSection) - 1 else { return }
        footerRefreshTrigger.onNext(())
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView, let textLabel = view.textLabel {
            textLabel.font = UIFont.systemFont(ofSize: 15)
            textLabel.theme.textColor = themeService.attribute { $0.text }
            view.contentView.theme.backgroundColor = themeService.attribute { $0.primaryDark }
        }
    }
}
