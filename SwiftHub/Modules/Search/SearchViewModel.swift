//
//  SearchViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class SearchViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let languageTrigger: Observable<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let languagesSelection: Observable<Void>
        let searchTypeSegmentSelection: Observable<SearchTypeSegments>
        let trendingPeriodSegmentSelection: Observable<TrendingPeriodSegments>
        let searchModeSelection: Observable<SearchModeSegments>
        let sortRepositorySelection: Observable<SortRepositoryItems>
        let sortUserSelection: Observable<SortUserItems>
        let selection: Driver<SearchSectionItem>
    }

    struct Output {
        let items: BehaviorRelay<[SearchSection]>
        let sortItems: Driver<[String]>
        let sortText: Driver<String>
        let totalCountText: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let languagesSelection: Driver<LanguagesViewModel>
        let repositorySelected: Driver<RepositoryViewModel>
        let userSelected: Driver<UserViewModel>
        let hidesTrendingPeriodSegment: Driver<Bool>
        let hidesSearchModeSegment: Driver<Bool>
        let hidesSortLabel: Driver<Bool>
    }

    let searchType = BehaviorRelay<SearchTypeSegments>(value: .repositories)
    let trendingPeriod = BehaviorRelay<TrendingPeriodSegments>(value: .daily)
    let searchMode = BehaviorRelay<SearchModeSegments>(value: .trending)

    let keyword = BehaviorRelay(value: "")
    let currentLanguage = BehaviorRelay<Language?>(value: Language.currentLanguage())
    let sortRepositoryItem = BehaviorRelay(value: SortRepositoryItems.bestMatch)
    let sortUserItem = BehaviorRelay(value: SortUserItems.bestMatch)

    let repositorySearchElements = BehaviorRelay(value: RepositorySearch())
    let userSearchElements = BehaviorRelay(value: UserSearch())

    var repositoriesPage = 1
    var usersPage = 1

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[SearchSection]>(value: [])
        let trendingRepositoryElements = BehaviorRelay<[TrendingRepository]>(value: [])
        let trendingUserElements = BehaviorRelay<[TrendingUser]>(value: [])
        let languageElements = BehaviorRelay<[Language]>(value: [])
        let repositorySelected = PublishSubject<Repository>()
        let userSelected = PublishSubject<User>()
        let dismissKeyboard = input.selection.mapToVoid()

        input.searchTypeSegmentSelection.bind(to: searchType).disposed(by: rx.disposeBag)
        input.trendingPeriodSegmentSelection.bind(to: trendingPeriod).disposed(by: rx.disposeBag)
        input.searchModeSelection.bind(to: searchMode).disposed(by: rx.disposeBag)

        input.keywordTrigger.skip(1).debounce(DispatchTimeInterval.milliseconds(500)).distinctUntilChanged().asObservable()
            .bind(to: keyword).disposed(by: rx.disposeBag)

        Observable.combineLatest(keyword, currentLanguage).map { keyword, currentLanguage in
            return keyword.isEmpty && currentLanguage == nil ? .trending: .search
        }.asObservable().bind(to: searchMode).disposed(by: rx.disposeBag)

        input.sortRepositorySelection.bind(to: sortRepositoryItem).disposed(by: rx.disposeBag)
        input.sortUserSelection.bind(to: sortUserItem).disposed(by: rx.disposeBag)

        Observable.combineLatest(keyword, currentLanguage, sortRepositoryItem)
            .filter({ (keyword, currentLanguage, sortRepositoryItem) -> Bool in
                return keyword.isNotEmpty || currentLanguage != nil
            })
            .flatMapLatest({ [weak self] (keyword, currentLanguage, sortRepositoryItem) -> Observable<RxSwift.Event<RepositorySearch>> in
                guard let self = self else { return Observable.just(RxSwift.Event.next(RepositorySearch())) }
                self.repositoriesPage = 1
                let query = self.makeQuery()
                let sort = sortRepositoryItem.sortValue
                let order = sortRepositoryItem.orderValue
                return self.provider.searchRepositories(query: query, sort: sort, order: order, page: self.repositoriesPage, endCursor: nil)
                    .trackActivity(self.loading)
                    .trackActivity(self.headerLoading)
                    .trackError(self.error)
                    .materialize()
            }).subscribe(onNext: { [weak self] (event) in
                switch event {
                case .next(let result):
                    self?.repositorySearchElements.accept(result)
                default: break
                }
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<RxSwift.Event<RepositorySearch>> in
            guard let self = self else { return Observable.just(RxSwift.Event.next(RepositorySearch())) }
            if self.searchMode.value != .search || !self.repositorySearchElements.value.hasNextPage {
                var result = RepositorySearch()
                result.totalCount = self.repositorySearchElements.value.totalCount
                return Observable.just(RxSwift.Event.next(result))
                    .trackActivity(self.footerLoading) // for force stoping table footer animation
            }
            self.repositoriesPage += 1
            let query = self.makeQuery()
            let sort = self.sortRepositoryItem.value.sortValue
            let order = self.sortRepositoryItem.value.orderValue
            let endCursor = self.repositorySearchElements.value.endCursor
            return self.provider.searchRepositories(query: query, sort: sort, order: order, page: self.repositoriesPage, endCursor: endCursor)
                .trackActivity(self.loading)
                .trackActivity(self.footerLoading)
                .trackError(self.error)
                .materialize()
        }).subscribe(onNext: { [weak self] (event) in
            switch event {
            case .next(let result):
                var newResult = result
                newResult.items = (self?.repositorySearchElements.value.items ?? []) + result.items
                self?.repositorySearchElements.accept(newResult)
            default: break
            }
        }).disposed(by: rx.disposeBag)

        Observable.combineLatest(keyword, currentLanguage, sortUserItem)
            .filter({ (keyword, currentLanguage, sortRepositoryItem) -> Bool in
                return keyword.isNotEmpty || currentLanguage != nil
            })
            .flatMapLatest({ [weak self] (keyword, currentLanguage, sortUserItem) -> Observable<RxSwift.Event<UserSearch>> in
                guard let self = self else { return Observable.just(RxSwift.Event.next(UserSearch())) }
                self.usersPage = 1
                let query = self.makeQuery()
                let sort = sortUserItem.sortValue
                let order = sortUserItem.orderValue
                return self.provider.searchUsers(query: query, sort: sort, order: order, page: self.usersPage, endCursor: nil)
                    .trackActivity(self.loading)
                    .trackActivity(self.headerLoading)
                    .trackError(self.error)
                    .materialize()
            }).subscribe(onNext: { [weak self] (event) in
                switch event {
                case .next(let result):
                    self?.userSearchElements.accept(result)
                default: break
                }
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<RxSwift.Event<UserSearch>> in
            guard let self = self else { return Observable.just(RxSwift.Event.next(UserSearch())) }
            if self.searchMode.value != .search || !self.userSearchElements.value.hasNextPage {
                var result = UserSearch()
                result.totalCount = self.userSearchElements.value.totalCount
                return Observable.just(RxSwift.Event.next(UserSearch()))
            }
            self.usersPage += 1
            let query = self.makeQuery()
            let sort = self.sortUserItem.value.sortValue
            let order = self.sortUserItem.value.orderValue
            let endCursor = self.userSearchElements.value.endCursor
            return self.provider.searchUsers(query: query, sort: sort, order: order, page: self.usersPage, endCursor: endCursor)
                .trackActivity(self.loading)
                .trackActivity(self.footerLoading)
                .trackError(self.error)
                .materialize()
        }).subscribe(onNext: { [weak self] (event) in
            switch event {
            case .next(let result):
                var newResult = result
                newResult.items = (self?.userSearchElements.value.items ?? []) + result.items
                self?.userSearchElements.accept(newResult)
            default: break
            }
        }).disposed(by: rx.disposeBag)

        keyword.asDriver().debounce(DispatchTimeInterval.milliseconds(300)).filterEmpty().drive(onNext: { (keyword) in
            analytics.log(.search(keyword: keyword))
        }).disposed(by: rx.disposeBag)

        Observable.just(()).flatMapLatest { () -> Observable<[Language]> in
            return self.provider.languages()
                .trackActivity(self.loading)
                .trackError(self.error)
            }.subscribe(onNext: { (items) in
                languageElements.accept(items)
            }, onError: { (error) in
                logError(error.localizedDescription)
            }).disposed(by: rx.disposeBag)

        let trendingPeriodSegment = BehaviorRelay(value: TrendingPeriodSegments.daily)
        input.trendingPeriodSegmentSelection.bind(to: trendingPeriodSegment).disposed(by: rx.disposeBag)

        let trendingTrigger = Observable.of(input.headerRefresh.skip(1),
                                            input.trendingPeriodSegmentSelection.mapToVoid().skip(1),
                                            currentLanguage.mapToVoid().skip(1),
                                            keyword.asObservable().map { $0.isEmpty }.filter { $0 == true }.mapToVoid()).merge()
        trendingTrigger.flatMapLatest { () -> Observable<RxSwift.Event<[TrendingRepository]>> in
            let language = self.currentLanguage.value?.urlParam ?? ""
            let since = trendingPeriodSegment.value.paramValue
            return self.provider.trendingRepositories(language: language, since: since)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
                .materialize()
            }.subscribe(onNext: { (event) in
                switch event {
                case .next(let items): trendingRepositoryElements.accept(items)
                default: break
                }
            }).disposed(by: rx.disposeBag)

        trendingTrigger.flatMapLatest { () -> Observable<RxSwift.Event<[TrendingUser]>> in
            let language = self.currentLanguage.value?.urlParam ?? ""
            let since = trendingPeriodSegment.value.paramValue
            return self.provider.trendingDevelopers(language: language, since: since)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
                .materialize()
            }.subscribe(onNext: { (event) in
                switch event {
                case .next(let items): trendingUserElements.accept(items)
                default: break
                }
            }).disposed(by: rx.disposeBag)

        input.selection.drive(onNext: { (item) in
            switch item {
            case .trendingRepositoriesItem(let cellViewModel):
                repositorySelected.onNext(Repository(repo: cellViewModel.repository))
            case .trendingUsersItem(let cellViewModel):
                userSelected.onNext(User(user: cellViewModel.user))
            case .repositoriesItem(let cellViewModel):
                repositorySelected.onNext(cellViewModel.repository)
            case .usersItem(let cellViewModel):
                userSelected.onNext(cellViewModel.user)
            }
        }).disposed(by: rx.disposeBag)

        Observable.combineLatest(trendingRepositoryElements, trendingUserElements, repositorySearchElements, userSearchElements, searchType, searchMode)
            .map { (trendingRepositories, trendingUsers, repositories, users, searchType, searchMode) -> [SearchSection] in
                var elements: [SearchSection] = []
                let language = self.currentLanguage.value?.displayName()
                let since = trendingPeriodSegment.value
                var title = ""
                switch searchMode {
                case .trending: title = language != nil ?
                    R.string.localizable.searchTrendingSectionWithLanguageTitle.key.localizedFormat("\(language ?? "")") :
                    R.string.localizable.searchTrendingSectionTitle.key.localized()
                case .search: title = language != nil ?
                    R.string.localizable.searchSearchSectionWithLanguageTitle.key.localizedFormat("\(language ?? "")") :
                    R.string.localizable.searchSearchSectionTitle.key.localized()
                }

                switch searchType {
                case .repositories:
                    switch searchMode {
                    case .trending:
                        let repositories = trendingRepositories.map({ (repository) -> SearchSectionItem in
                            let cellViewModel = TrendingRepositoryCellViewModel(with: repository, since: since)
                            return SearchSectionItem.trendingRepositoriesItem(cellViewModel: cellViewModel)
                        })
                        if repositories.isNotEmpty {
                            elements.append(SearchSection.repositories(title: title, items: repositories))
                        }
                    case .search:
                        let repositories = repositories.items.map({ (repository) -> SearchSectionItem in
                            let cellViewModel = RepositoryCellViewModel(with: repository)
                            return SearchSectionItem.repositoriesItem(cellViewModel: cellViewModel)
                        })
                        if repositories.isNotEmpty {
                            elements.append(SearchSection.repositories(title: title, items: repositories))
                        }
                    }
                case .users:
                    switch searchMode {
                    case .trending:
                        let users = trendingUsers.map({ (user) -> SearchSectionItem in
                            let cellViewModel = TrendingUserCellViewModel(with: user)
                            return SearchSectionItem.trendingUsersItem(cellViewModel: cellViewModel)
                        })
                        if users.isNotEmpty {
                            elements.append(SearchSection.users(title: title, items: users))
                        }
                    case .search:
                        let users = users.items.map({ (user) -> SearchSectionItem in
                            let cellViewModel = UserCellViewModel(with: user)
                            return SearchSectionItem.usersItem(cellViewModel: cellViewModel)
                        })
                        if users.isNotEmpty {
                            elements.append(SearchSection.users(title: title, items: users))
                        }
                    }
                }
                return elements
        }.bind(to: elements).disposed(by: rx.disposeBag)

        let textDidBeginEditing = input.textDidBeginEditing

        let repositoryDetails = repositorySelected.map({ (repository) -> RepositoryViewModel in
            let viewModel = RepositoryViewModel(repository: repository, provider: self.provider)
            return viewModel
        }).asDriverOnErrorJustComplete()

        let userDetails = userSelected.map({ (user) -> UserViewModel in
            let viewModel = UserViewModel(user: user, provider: self.provider)
            return viewModel
        }).asDriverOnErrorJustComplete()

        let languagesSelection = input.languagesSelection.asDriver(onErrorJustReturn: ()).map { () -> LanguagesViewModel in
            let viewModel = LanguagesViewModel(currentLanguage: self.currentLanguage.value, languages: languageElements.value, provider: self.provider)
            viewModel.currentLanguage.skip(1).bind(to: self.currentLanguage).disposed(by: self.rx.disposeBag)
            return viewModel
        }

        let hidesTrendingPeriodSegment = searchMode.map { $0 != .trending }.asDriver(onErrorJustReturn: false)

        let hidesSearchModeSegment = Observable.combineLatest(input.keywordTrigger.asObservable().map { $0.isNotEmpty }, currentLanguage.map { $0 == nil })
            .map { $0 || $1 }.asDriver(onErrorJustReturn: false)

        let hidesSortLabel = searchMode.map { $0 == .trending }.asDriver(onErrorJustReturn: false)

        let sortItems = Observable.combineLatest(searchType, input.languageTrigger)
            .map { (searchType, _) -> [String] in
            switch searchType {
            case .repositories: return SortRepositoryItems.allItems()
            case .users: return SortUserItems.allItems()
            }
        }.asDriver(onErrorJustReturn: [])

        let sortText = Observable.combineLatest(searchType, sortRepositoryItem, sortUserItem, input.languageTrigger)
            .map { (searchType, sortRepositoryItem, sortUserItem, _) -> String in
                switch searchType {
                case .repositories: return sortRepositoryItem.title + " ▼"
                case .users: return sortUserItem.title + " ▼"
                }
        }.asDriver(onErrorJustReturn: "")

        let totalCountText = Observable.combineLatest(searchType, repositorySearchElements, userSearchElements, input.languageTrigger)
            .map { (searchType, repositorySearchElements, userSearchElements, _) -> String in
                switch searchType {
                case .repositories: return R.string.localizable.searchRepositoriesTotalCountTitle.key.localizedFormat("\(repositorySearchElements.totalCount.kFormatted())")
                case .users: return R.string.localizable.searchUsersTotalCountTitle.key.localizedFormat("\(userSearchElements.totalCount.kFormatted())")
                }
        }.asDriver(onErrorJustReturn: "")

        return Output(items: elements,
                      sortItems: sortItems,
                      sortText: sortText,
                      totalCountText: totalCountText,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      languagesSelection: languagesSelection,
                      repositorySelected: repositoryDetails,
                      userSelected: userDetails,
                      hidesTrendingPeriodSegment: hidesTrendingPeriodSegment,
                      hidesSearchModeSegment: hidesSearchModeSegment,
                      hidesSortLabel: hidesSortLabel)
    }

    func makeQuery() -> String {
        var query = keyword.value
        if let language = currentLanguage.value?.urlParam {
            query += " language:\(language)"
        }
        return query
    }
}
