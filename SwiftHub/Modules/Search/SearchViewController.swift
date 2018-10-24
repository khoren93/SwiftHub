//
//  SearchViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let repositoryReuseIdentifier = R.reuseIdentifier.repositoryCell
private let userReuseIdentifier = R.reuseIdentifier.userCell

enum SearchSegments: Int {
    case repositories, users

    var title: String {
        switch self {
        case .repositories: return R.string.localizable.searchRepositoriesSegmentTitle.key.localized()
        case .users: return R.string.localizable.searchUsersSegmentTitle.key.localized()
        }
    }
}

class SearchViewController: TableViewController {

    var viewModel: SearchViewModel!

    lazy var segmentedControl: SegmentedControl = {
        let items = [SearchSegments.repositories.title, SearchSegments.users.title]
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
            self?.segmentedControl.setTitle(SearchSegments.repositories.title, forSegmentAt: 0)
            self?.segmentedControl.setTitle(SearchSegments.users.title, forSegmentAt: 1)
        }).disposed(by: rx.disposeBag)

        stackView.insertArrangedSubview(searchBar, at: 0)

        tableView.register(R.nib.repositoryCell)
        tableView.register(R.nib.userCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let segmentSelected = Observable.of(segmentedControl.rx.selectedSegmentIndex.map { SearchSegments(rawValue: $0)! }).merge()
        let input = SearchViewModel.Input(keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                          textDidBeginEditing: searchBar.rx.textDidBeginEditing.asDriver(),
                                          segmentSelection: segmentSelected,
                                          selection: tableView.rx.modelSelected(SearchSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .repositoriesItem(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: repositoryReuseIdentifier, for: indexPath)!
                cell.bind(to: cellViewModel)
                return cell
            case .usersItem(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: userReuseIdentifier, for: indexPath)!
                cell.bind(to: cellViewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        output.repositorySelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .repositoryDetails(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.userSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.dismissKeyboard.drive(onNext: { [weak self] () in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: rx.disposeBag)
    }
}
