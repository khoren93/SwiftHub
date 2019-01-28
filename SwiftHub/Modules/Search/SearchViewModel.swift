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
        let trigger: Observable<Void>
        let languageTrigger: Observable<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let languagesSelection: Observable<Void>
        let segmentSelection: Observable<SearchSegments>
        let trendingPeriodSegmentSelection: Observable<TrendingPeriodSegments>
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
        let hidesSortLabel: Driver<Bool>
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[SearchSection]>(value: [])

        let trendingRepositoryElements = BehaviorRelay<[TrendingRepository]>(value: [])
        let trendingUserElements = BehaviorRelay<[TrendingUser]>(value: [])
        let repositoryElements = BehaviorRelay<[Repository]>(value: [])
        let userElements = BehaviorRelay<[User]>(value: [])
        let repositoryTotalItems = BehaviorRelay(value: 0)
        let userTotalItems = BehaviorRelay(value: 0)

        let languageElements = BehaviorRelay<Languages?>(value: nil)
        let currentLanguage = BehaviorRelay<Language?>(value: Language.currentLanguage())

        let repositorySelected = PublishSubject<Repository>()
        let userSelected = PublishSubject<User>()

        let dismissKeyboard = input.selection.mapToVoid()

        let keyword = BehaviorRelay(value: "")
        input.keywordTrigger.skip(1).debounce(0.5).distinctUntilChanged().asObservable()
            .bind(to: keyword).disposed(by: rx.disposeBag)

        let showTrendings = BehaviorRelay(value: true)
        keyword.map { $0.isEmpty }
            .bind(to: showTrendings).disposed(by: rx.disposeBag)

        let sortRepositoryItem = BehaviorRelay(value: SortRepositoryItems.bestMatch)
        let sortUserItem = BehaviorRelay(value: SortUserItems.bestMatch)

        input.sortRepositorySelection.bind(to: sortRepositoryItem).disposed(by: rx.disposeBag)
        input.sortUserSelection.bind(to: sortUserItem).disposed(by: rx.disposeBag)

        Observable.combineLatest(keyword.asObservable().filterEmpty(), currentLanguage, sortRepositoryItem)
            .flatMapLatest({ [weak self] (keyword, currentLanguage, sortRepositoryItem) -> Observable<RxSwift.Event<RepositorySearch>> in
                guard let self = self else { return Observable.just(RxSwift.Event.next(RepositorySearch())) }
                var query = keyword
                let sort = sortRepositoryItem.sortValue
                let order = sortRepositoryItem.orderValue
                if let language = currentLanguage?.name {
                    query += " language:\(language)"
                }
                return self.provider.searchRepositories(query: query, sort: sort, order: order, page: self.page)
                    .trackActivity(self.loading)
                    .trackActivity(self.headerLoading)
                    .trackError(self.error)
                    .materialize()
            }).subscribe(onNext: { (event) in
                switch event {
                case .next(let result):
                    repositoryElements.accept(result.items)
                    repositoryTotalItems.accept(result.totalCount)
                default: break
                }
            }).disposed(by: rx.disposeBag)

        Observable.combineLatest(keyword.asObservable().filterEmpty(), currentLanguage, sortUserItem)
            .flatMapLatest({ [weak self] (keyword, currentLanguage, sortUserItem) -> Observable<RxSwift.Event<UserSearch>> in
                guard let self = self else { return Observable.just(RxSwift.Event.next(UserSearch())) }
                var query = keyword
                let sort = sortUserItem.sortValue
                let order = sortUserItem.orderValue
                if let language = currentLanguage?.name {
                    query += " language:\(language)"
                }
                return self.provider.searchUsers(query: query, sort: sort, order: order, page: self.page)
                    .trackActivity(self.loading)
                    .trackActivity(self.headerLoading)
                    .trackError(self.error)
                    .materialize()
            }).subscribe(onNext: { (event) in
                switch event {
                case .next(let result):
                    userElements.accept(result.items)
                    userTotalItems.accept(result.totalCount)
                default: break
                }
            }).disposed(by: rx.disposeBag)

        keyword.asDriver().debounce(3.0).filterEmpty().drive(onNext: { (keyword) in
            analytics.log(.search(keyword: keyword))
        }).disposed(by: rx.disposeBag)

        Observable.just(()).flatMapLatest { () -> Observable<Languages> in
            return self.provider.languages()
                .trackActivity(self.loading)
                .trackError(self.error)
            }.subscribe(onNext: { (item) in
                languageElements.accept(item)
            }).disposed(by: rx.disposeBag)

        let trendingPeriodSegment = BehaviorRelay(value: TrendingPeriodSegments.daily)
        input.trendingPeriodSegmentSelection.bind(to: trendingPeriodSegment).disposed(by: rx.disposeBag)

        let trendingTrigger = Observable.of(input.trigger,
                                            input.trendingPeriodSegmentSelection.mapToVoid(),
                                            currentLanguage.mapToVoid(),
                                            keyword.asObservable().map { $0.isEmpty }.filter { $0 == true }.mapToVoid()).merge()
        trendingTrigger.flatMapLatest { () -> Observable<RxSwift.Event<[TrendingRepository]>> in
            let language = currentLanguage.value?.urlParam ?? ""
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
            let language = currentLanguage.value?.urlParam ?? ""
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

        Observable.combineLatest(trendingRepositoryElements, trendingUserElements, repositoryElements, userElements, input.segmentSelection)
            .map { (trendingRepositories, trendingUsers, repositories, users, segment) -> [SearchSection] in
                var elements: [SearchSection] = []
                let showTrendings = showTrendings.value
                let language = currentLanguage.value?.name
                let since = trendingPeriodSegment.value
                let trendingTitle = language != nil ?
                    R.string.localizable.searchTrendingSectionWithLanguageTitle.key.localizedFormat("\(language ?? "")") :
                    R.string.localizable.searchTrendingSectionTitle.key.localized()
                let searchTitle = language != nil ?
                    R.string.localizable.searchSearchSectionWithLanguageTitle.key.localizedFormat("\(language ?? "")") :
                    R.string.localizable.searchSearchSectionTitle.key.localized()
                let title = showTrendings ? trendingTitle: searchTitle
                switch segment {
                case .repositories:
                    if showTrendings {
                        let repositories = trendingRepositories.map({ (repository) -> SearchSectionItem in
                            let cellViewModel = TrendingRepositoryCellViewModel(with: repository, since: since)
                            return SearchSectionItem.trendingRepositoriesItem(cellViewModel: cellViewModel)
                        })
                        if repositories.isNotEmpty {
                            elements.append(SearchSection.repositories(title: title, items: repositories))
                        }
                    } else {
                        let repositories = repositories.map({ (repository) -> SearchSectionItem in
                            let cellViewModel = RepositoryCellViewModel(with: repository)
                            return SearchSectionItem.repositoriesItem(cellViewModel: cellViewModel)
                        })
                        if repositories.isNotEmpty {
                            elements.append(SearchSection.repositories(title: title, items: repositories))
                        }
                    }
                case .users:
                    if showTrendings {
                        let users = trendingUsers.map({ (user) -> SearchSectionItem in
                            let cellViewModel = TrendingUserCellViewModel(with: user)
                            return SearchSectionItem.trendingUsersItem(cellViewModel: cellViewModel)
                        })
                        if users.isNotEmpty {
                            elements.append(SearchSection.users(title: title, items: users))
                        }
                    } else {
                        let users = users.map({ (user) -> SearchSectionItem in
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
            let viewModel = LanguagesViewModel(currentLanguage: currentLanguage.value, languages: languageElements.value, provider: self.provider)
            viewModel.currentLanguage.skip(1).bind(to: currentLanguage).disposed(by: self.rx.disposeBag)
            return viewModel
        }

        let hidesTrendingPeriodSegment = showTrendings.not().asDriver(onErrorJustReturn: false)

        let hidesSortLabel = input.keywordTrigger.map { $0.isEmpty }.asDriver(onErrorJustReturn: false)

        let sortItems = Observable.combineLatest(input.segmentSelection, input.languageTrigger).map { (segment, _) -> [String] in
            switch segment {
            case .repositories: return SortRepositoryItems.allItems()
            case .users: return SortUserItems.allItems()
            }
        }.asDriver(onErrorJustReturn: [])

        let sortText = Observable.combineLatest(input.segmentSelection, sortRepositoryItem, sortUserItem, input.languageTrigger)
            .map { (segment, sortRepositoryItem, sortUserItem, _) -> String in
                switch segment {
                case .repositories: return sortRepositoryItem.title + " ▼"
                case .users: return sortUserItem.title + " ▼"
                }
            }.asDriver(onErrorJustReturn: "")

        let totalCountText = Observable.combineLatest(input.segmentSelection, repositoryTotalItems, userTotalItems, input.languageTrigger)
            .map { (segment, repositoryTotalItems, userTotalItems, _) -> String in
                switch segment {
                case .repositories: return R.string.localizable.searchRepositoriesTotalCountTitle.key.localizedFormat("\(repositoryTotalItems.kFormatted())")
                case .users: return R.string.localizable.searchUsersTotalCountTitle.key.localizedFormat("\(userTotalItems.kFormatted())")
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
                      hidesSortLabel: hidesSortLabel)
    }
}
