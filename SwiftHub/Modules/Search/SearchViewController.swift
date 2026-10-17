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

private let trendingRepositoryReuseIdentifier = TrendingRepositoryCell.reuseID
private let trendingUserReuseIdentifier = TrendingUserCell.reuseID
private let repositoryReuseIdentifier = RepositoryCell.reuseID
private let userReuseIdentifier = UserCell.reuseID

enum SearchTypeSegments: Int {
    case repositories, users

    var title: String {
        switch self {
        case .repositories: return String(localized: .searchRepositoriesSegmentTitle)
        case .users: return String(localized: .searchUsersSegmentTitle)
        }
    }
}

enum TrendingPeriodSegments: Int {
    case daily, weekly, montly

    var title: String {
        switch self {
        case .daily: return String(localized: .searchDailySegmentTitle)
        case .weekly: return String(localized: .searchWeeklySegmentTitle)
        case .montly: return String(localized: .searchMonthlySegmentTitle)
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

enum SearchModeSegments: Int {
    case trending, search

    var title: String {
        switch self {
        case .trending: return String(localized: .searchTrendingSegmentTitle)
        case .search: return String(localized: .searchSearchSegmentTitle)
        }
    }
}

enum SortRepositoryItems: Int {
    case bestMatch, mostStars, fewestStars, mostForks, fewestForks, recentlyUpdated, lastRecentlyUpdated

    var title: String {
        switch self {
        case .bestMatch: return String(localized: .searchSortRepositoriesBestMatchTitle)
        case .mostStars: return String(localized: .searchSortRepositoriesMostStarsTitle)
        case .fewestStars: return String(localized: .searchSortRepositoriesFewestStarsTitle)
        case .mostForks: return String(localized: .searchSortRepositoriesMostForksTitle)
        case .fewestForks: return String(localized: .searchSortRepositoriesFewestForksTitle)
        case .recentlyUpdated: return String(localized: .searchSortRepositoriesRecentlyUpdatedTitle)
        case .lastRecentlyUpdated: return String(localized: .searchSortRepositoriesLastRecentlyUpdatedTitle)
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
        case .bestMatch: return String(localized: .searchSortUsersBestMatchTitle)
        case .mostFollowers: return String(localized: .searchSortUsersMostFollowersTitle)
        case .fewestFollowers: return String(localized: .searchSortUsersFewestFollowersTitle)
        case .mostRecentlyJoined: return String(localized: .searchSortUsersMostRecentlyJoinedTitle)
        case .leastRecentlyJoined: return String(localized: .searchSortUsersLeastRecentlyJoinedTitle)
        case .mostRepositories: return String(localized: .searchSortUsersMostRepositoriesTitle)
        case .fewestRepositories: return String(localized: .searchSortUsersFewestRepositoriesTitle)
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
        case .bestMatch, .mostFollowers, .mostRecentlyJoined, .mostRepositories: return "desc"
        case .fewestFollowers, .leastRecentlyJoined, .fewestRepositories: return "asc"
        }
    }

    static func allItems() -> [String] {
        return (0...SortUserItems.fewestRepositories.rawValue)
            .map { SortUserItems(rawValue: $0)!.title }
    }
}

class SearchViewController: TableViewController {

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: UIImage(resource: .iconNavigationLanguage), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var segmentedControl: SegmentedControl = {
        let titles = [SearchTypeSegments.repositories.title, SearchTypeSegments.users.title]
        let view = SegmentedControl(sectionTitles: titles)
        view.selectedSegmentIndex = 0
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(220)
        })
        return view
    }()

    let trendingPeriodView = View()
    lazy var trendingPeriodSegmentedControl: SegmentedControl = {
        let items = [TrendingPeriodSegments.daily.title, TrendingPeriodSegments.weekly.title, TrendingPeriodSegments.montly.title]
        let view = SegmentedControl(sectionTitles: items)
        view.selectedSegmentIndex = 0
        return view
    }()

    let searchModeView = View()
    lazy var searchModeSegmentedControl: SegmentedControl = {
        let titles = [SearchModeSegments.trending.title, SearchModeSegments.search.title]
        let view = SegmentedControl(sectionTitles: titles)
        view.selectedSegmentIndex = 0
        return view
    }()

    lazy var totalCountLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(14)
        view.leftTextInset = self.inset
        return view
    }()

    lazy var sortButton: UIButton = {
        let view = UIButton(type: .system)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        view.contentHorizontalAlignment = .trailing
        view.showsMenuAsPrimaryAction = true
        view.menu = UIMenu(children: [UIDeferredMenuElement.uncached { [weak self] completion in
            completion(self?.sortActions() ?? [])
        }])
        return view
    }()

    lazy var labelsStackView: StackView = {
        let view = StackView(arrangedSubviews: [self.totalCountLabel, self.sortButton])
        view.axis = .horizontal
        view.isLayoutMarginsRelativeArrangement = true
        view.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: self.inset)
        return view
    }()

    var sortItems: [String] = []
    let sortRepositoryItem = BehaviorRelay(value: SortRepositoryItems.bestMatch)
    let sortUserItem = BehaviorRelay(value: SortUserItems.bestMatch)

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = rightBarButton

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.searchBar.placeholder = String(localized: .searchSearchBarPlaceholder)
            self?.segmentedControl.sectionTitles = [SearchTypeSegments.repositories.title,
                                                    SearchTypeSegments.users.title]
            self?.trendingPeriodSegmentedControl.sectionTitles = [TrendingPeriodSegments.daily.title,
                                                                  TrendingPeriodSegments.weekly.title,
                                                                  TrendingPeriodSegments.montly.title]
            self?.searchModeSegmentedControl.sectionTitles = [SearchModeSegments.trending.title,
                                                              SearchModeSegments.search.title]
        }).disposed(by: rx.disposeBag)

        trendingPeriodView.addSubview(trendingPeriodSegmentedControl)
        trendingPeriodSegmentedControl.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(self.inset)
            make.top.bottom.equalToSuperview()
        }

        searchModeView.addSubview(searchModeSegmentedControl)
        searchModeSegmentedControl.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(self.inset)
        }

        stackView.insertArrangedSubview(labelsStackView, at: 0)
        stackView.insertArrangedSubview(trendingPeriodView, at: 0)
        stackView.insertArrangedSubview(searchBar, at: 0)
        stackView.addArrangedSubview(searchModeView)

        labelsStackView.snp.makeConstraints { (make) in
            make.height.equalTo(30)
        }

        tableView.registerNib(TrendingRepositoryCell.self)
        tableView.registerNib(TrendingUserCell.self)
        tableView.registerNib(RepositoryCell.self)
        tableView.registerNib(UserCell.self)

        totalCountLabel.theme.textColor = themeService.attribute { $0.text }
        sortButton.theme.tintColor = themeService.attribute { $0.text }
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? SearchViewModel else { return }

        let searchTypeSegmentSelected = segmentedControl.segmentSelection.map { SearchTypeSegments(rawValue: $0)! }
        let trendingPerionSegmentSelected = trendingPeriodSegmentedControl.segmentSelection.map { TrendingPeriodSegments(rawValue: $0)! }
        let searchModeSegmentSelected = searchModeSegmentedControl.segmentSelection.map { SearchModeSegments(rawValue: $0)! }
        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger, themeService.typeStream.mapToVoid()).merge()
        let input = SearchViewModel.Input(headerRefresh: refresh,
                                          footerRefresh: footerRefreshTrigger,
                                          languageTrigger: languageChanged.asObservable(),
                                          keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                          textDidBeginEditing: searchBar.rx.textDidBeginEditing.asDriver(),
                                          languagesSelection: rightBarButton.rx.tap.asObservable(),
                                          searchTypeSegmentSelection: searchTypeSegmentSelected,
                                          trendingPeriodSegmentSelection: trendingPerionSegmentSelected,
                                          searchModeSelection: searchModeSegmentSelected,
                                          sortRepositorySelection: sortRepositoryItem.asObservable(),
                                          sortUserSelection: sortUserItem.asObservable(),
                                          selection: tableView.rx.modelSelected(SearchSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<SearchSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .trendingRepositoriesItem(let cellViewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: trendingRepositoryReuseIdentifier, for: indexPath) as? TrendingRepositoryCell)!
                cell.bind(to: cellViewModel)
                return cell
            case .trendingUsersItem(let cellViewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: trendingUserReuseIdentifier, for: indexPath) as? TrendingUserCell)!
                cell.bind(to: cellViewModel)
                return cell
            case .repositoriesItem(let cellViewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: repositoryReuseIdentifier, for: indexPath) as? RepositoryCell)!
                cell.bind(to: cellViewModel)
                return cell
            case .usersItem(let cellViewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: userReuseIdentifier, for: indexPath) as? UserCell)!
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
        output.hidesSearchModeSegment.drive(searchModeView.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesSortLabel.drive(labelsStackView.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesSortLabel.drive(totalCountLabel.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesSortLabel.drive(sortButton.rx.isHidden).disposed(by: rx.disposeBag)

        output.sortItems.drive(onNext: { [weak self] (items) in
            self?.sortItems = items
        }).disposed(by: rx.disposeBag)

        output.totalCountText.drive(totalCountLabel.rx.text).disposed(by: rx.disposeBag)
        output.sortText.drive(sortButton.rx.title(for: .normal)).disposed(by: rx.disposeBag)

        viewModel.searchMode.asDriver().drive(onNext: { [weak self] (searchMode) in
            guard let self = self else { return }
            self.searchModeSegmentedControl.selectedSegmentIndex = searchMode.rawValue

            self.isFooterRefreshEnabled = searchMode == .search
        }).disposed(by: rx.disposeBag)
    }

    func sortActions() -> [UIMenuElement] {
        let isRepositories = segmentedControl.selectedSegmentIndex == SearchTypeSegments.repositories.rawValue
        let selectedIndex = isRepositories ? sortRepositoryItem.value.rawValue : sortUserItem.value.rawValue
        return sortItems.enumerated().map { (index, title) in
            UIAction(title: title, state: index == selectedIndex ? .on : .off) { [weak self] _ in
                if isRepositories {
                    if let item = SortRepositoryItems(rawValue: index) {
                        self?.sortRepositoryItem.accept(item)
                    }
                } else {
                    if let item = SortUserItems(rawValue: index) {
                        self?.sortUserItem.accept(item)
                    }
                }
            }
        }
    }
}
