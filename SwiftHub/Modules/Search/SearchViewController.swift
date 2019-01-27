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

private let trendingRepositoryReuseIdentifier = R.reuseIdentifier.trendingRepositoryCell
private let trendingUserReuseIdentifier = R.reuseIdentifier.trendingUserCell
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

enum TrendingPeriodSegments: Int {
    case daily, weekly, montly

    var title: String {
        switch self {
        case .daily: return R.string.localizable.searchDailySegmentTitle.key.localized()
        case .weekly: return R.string.localizable.searchWeeklySegmentTitle.key.localized()
        case .montly: return R.string.localizable.searchMonthlySegmentTitle.key.localized()
        }
    }

    var paramValue: String {
        switch self {
        case .daily: return "daily"
        case .weekly: return "weekly"
        case .montly: return "monthly"
        }
    }
}

enum SortRepositoryItems: Int {
    case bestMatch, mostStars, fewestStars, mostForks, fewestForks, recentlyUpdated, lastRecentlyUpdated

    var title: String {
        switch self {
        case .bestMatch: return R.string.localizable.searchSortRepositoriesBestMatchTitle.key.localized()
        case .mostStars: return R.string.localizable.searchSortRepositoriesMostStarsTitle.key.localized()
        case .fewestStars: return R.string.localizable.searchSortRepositoriesFewestStarsTitle.key.localized()
        case .mostForks: return R.string.localizable.searchSortRepositoriesMostForksTitle.key.localized()
        case .fewestForks: return R.string.localizable.searchSortRepositoriesFewestForksTitle.key.localized()
        case .recentlyUpdated: return R.string.localizable.searchSortRepositoriesRecentlyUpdatedTitle.key.localized()
        case .lastRecentlyUpdated: return R.string.localizable.searchSortRepositoriesLastRecentlyUpdatedTitle.key.localized()
        }
    }

    var sortValue: String {
        switch self {
        case .bestMatch: return ""
        case .mostStars, .fewestStars: return "stars"
        case .mostForks, .fewestForks: return "forks"
        case .recentlyUpdated, .lastRecentlyUpdated: return "updated"
        }
    }

    var orderValue: String {
        switch self {
        case .bestMatch: return ""
        case .mostStars, .mostForks, .recentlyUpdated: return "desc"
        case .fewestStars, .fewestForks, .lastRecentlyUpdated: return "asc"
        }
    }

    static func allItems() -> [String] {
        return (0...SortRepositoryItems.lastRecentlyUpdated.rawValue)
            .map { SortRepositoryItems(rawValue: $0)!.title }
    }
}

enum SortUserItems: Int {
    case bestMatch, mostFollowers, fewestFollowers, mostRecentlyJoined, leastRecentlyJoined, mostRepositories, fewestRepositories

    var title: String {
        switch self {
        case .bestMatch: return R.string.localizable.searchSortUsersBestMatchTitle.key.localized()
        case .mostFollowers: return R.string.localizable.searchSortUsersMostFollowersTitle.key.localized()
        case .fewestFollowers: return R.string.localizable.searchSortUsersFewestFollowersTitle.key.localized()
        case .mostRecentlyJoined: return R.string.localizable.searchSortUsersMostRecentlyJoinedTitle.key.localized()
        case .leastRecentlyJoined: return R.string.localizable.searchSortUsersLeastRecentlyJoinedTitle.key.localized()
        case .mostRepositories: return R.string.localizable.searchSortUsersMostRepositoriesTitle.key.localized()
        case .fewestRepositories: return R.string.localizable.searchSortUsersFewestRepositoriesTitle.key.localized()
        }
    }

    var sortValue: String {
        switch self {
        case .bestMatch: return ""
        case .mostFollowers, .fewestFollowers: return "followers"
        case .mostRecentlyJoined, .leastRecentlyJoined: return "joined"
        case .mostRepositories, .fewestRepositories: return "repositories"
        }
    }

    var orderValue: String {
        switch self {
        case .bestMatch: return ""
        case .mostFollowers, .mostRecentlyJoined, .mostRepositories: return "desc"
        case .fewestFollowers, .leastRecentlyJoined, .fewestRepositories: return "asc"
        }
    }

    static func allItems() -> [String] {
        return (0...SortUserItems.fewestRepositories.rawValue)
            .map { SortUserItems(rawValue: $0)!.title }
    }
}

class SearchViewController: TableViewController {

    var viewModel: SearchViewModel!

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_language(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var segmentedControl: SegmentedControl = {
        let items = [SearchSegments.repositories.title, SearchSegments.users.title]
        let view = SegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        return view
    }()

    let trendingPeriodView = View()
    lazy var trendingPeriodSegmentedControl: SegmentedControl = {
        let items = [TrendingPeriodSegments.daily.title, TrendingPeriodSegments.weekly.title, TrendingPeriodSegments.montly.title]
        let view = SegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        return view
    }()

    lazy var totalCountLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(14)
        view.leftTextInset = self.inset
        return view
    }()

    lazy var sortLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(14)
        view.textAlignment = .right
        view.rightTextInset = self.inset
        return view
    }()

    lazy var labelsStackView: StackView = {
        let view = StackView(arrangedSubviews: [self.totalCountLabel, self.sortLabel])
        view.axis = .horizontal
        return view
    }()

    lazy var sortDropDown: DropDownView = {
        let view = DropDownView(anchorView: self.tableView)
        return view
    }()

    let sortRepositoryItem = BehaviorRelay(value: SortRepositoryItems.bestMatch)
    let sortUserItem = BehaviorRelay(value: SortUserItems.bestMatch)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = rightBarButton

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.searchBar.placeholder = R.string.localizable.searchSearchBarPlaceholder.key.localized()
            self?.segmentedControl.setTitle(SearchSegments.repositories.title, forSegmentAt: 0)
            self?.segmentedControl.setTitle(SearchSegments.users.title, forSegmentAt: 1)
            self?.trendingPeriodSegmentedControl.setTitle(TrendingPeriodSegments.daily.title, forSegmentAt: 0)
            self?.trendingPeriodSegmentedControl.setTitle(TrendingPeriodSegments.weekly.title, forSegmentAt: 1)
            self?.trendingPeriodSegmentedControl.setTitle(TrendingPeriodSegments.montly.title, forSegmentAt: 2)
        }).disposed(by: rx.disposeBag)

        trendingPeriodView.addSubview(trendingPeriodSegmentedControl)
        trendingPeriodSegmentedControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(self.inset)
        }
        stackView.insertArrangedSubview(labelsStackView, at: 0)
        stackView.insertArrangedSubview(trendingPeriodView, at: 0)
        stackView.insertArrangedSubview(searchBar, at: 0)
//        stackView.addArrangedSubview(trendingPeriodSegmentedControl)

        labelsStackView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }

        sortDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            if self?.segmentedControl.selectedSegmentIndex == 0 {
                if let item = SortRepositoryItems(rawValue: index) {
                    self?.sortRepositoryItem.accept(item)
                }
            } else {
                if let item = SortUserItems(rawValue: index) {
                    self?.sortUserItem.accept(item)
                }
            }
        }

        tableView.register(R.nib.trendingRepositoryCell)
        tableView.register(R.nib.trendingUserCell)
        tableView.register(R.nib.repositoryCell)
        tableView.register(R.nib.userCell)
//        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil

        themeService.rx
            .bind({ $0.text }, to: [totalCountLabel.rx.textColor, sortLabel.rx.textColor])
            .disposed(by: rx.disposeBag)

        themeService.attrsStream.subscribe(onNext: { [weak self] (theme) in
            self?.sortDropDown.dimmedBackgroundColor = theme.primaryDark.withAlphaComponent(0.5)
        }).disposed(by: rx.disposeBag)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let segmentSelected = segmentedControl.rx.selectedSegmentIndex.map { SearchSegments(rawValue: $0)! }
        let trendingPerionSegmentSelected = trendingPeriodSegmentedControl.rx.selectedSegmentIndex.map { TrendingPeriodSegments(rawValue: $0)! }
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = SearchViewModel.Input(trigger: refresh,
                                          languageTrigger: languageChanged.asObservable(),
                                          keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                          textDidBeginEditing: searchBar.rx.textDidBeginEditing.asDriver(),
                                          languagesSelection: rightBarButton.rx.tap.asObservable(),
                                          segmentSelection: segmentSelected,
                                          trendingPeriodSegmentSelection: trendingPerionSegmentSelected,
                                          sortRepositorySelection: sortRepositoryItem.asObservable(),
                                          sortUserSelection: sortUserItem.asObservable(),
                                          selection: tableView.rx.modelSelected(SearchSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .trendingRepositoriesItem(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: trendingRepositoryReuseIdentifier, for: indexPath)!
                cell.bind(to: cellViewModel)
                return cell
            case .trendingUsersItem(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: trendingUserReuseIdentifier, for: indexPath)!
                cell.bind(to: cellViewModel)
                return cell
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

        output.languagesSelection.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .languages(viewModel: viewModel), sender: self, transition: .modal)
        }).disposed(by: rx.disposeBag)

        output.repositorySelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .repositoryDetails(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.userSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.dismissKeyboard.drive(onNext: { [weak self] () in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: rx.disposeBag)

        output.hidesTrendingPeriodSegment.drive(trendingPeriodView.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesSortLabel.drive(labelsStackView.rx.isHidden).disposed(by: rx.disposeBag)

        sortLabel.rx.tap().subscribe(onNext: { [weak self] () in
            self?.sortDropDown.show()
        }).disposed(by: rx.disposeBag)

        output.sortItems.drive(onNext: { [weak self] (items) in
            self?.sortDropDown.dataSource = items
            self?.sortDropDown.reloadAllComponents()
        }).disposed(by: rx.disposeBag)

        output.totalCountText.drive(totalCountLabel.rx.text).disposed(by: rx.disposeBag)
        output.sortText.drive(sortLabel.rx.text).disposed(by: rx.disposeBag)
    }
}
