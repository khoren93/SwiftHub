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
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let segmentSelection: Observable<SearchSegments>
        let selection: Driver<SearchSectionItem>
    }

    struct Output {
        let items: BehaviorRelay<[SearchSection]>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let repositorySelected: Driver<RepositoryViewModel>
        let userSelected: Driver<UserViewModel>
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[SearchSection]>(value: [])

        let repositoryElements = BehaviorRelay<[Repository]>(value: [])
        let userElements = BehaviorRelay<[User]>(value: [])

        let languageElements = BehaviorRelay<LanguageSection?>(value: nil)

        let repositorySelected = PublishSubject<Repository>()
        let userSelected = PublishSubject<User>()

        let dismissKeyboard = input.selection.mapToVoid()

        let keyword = BehaviorRelay(value: "")
        input.keywordTrigger.skip(1).throttle(0.5).distinctUntilChanged().asObservable().bind(to: keyword).disposed(by: rx.disposeBag)

        keyword.asObservable().filterEmpty().flatMapLatest({ [weak self] (keyword) -> Observable<[Repository]> in
            guard let self = self else { return Observable.just([]) }
            return self.provider.searchRepositories(query: keyword)
                .trackActivity(self.loading)
                .trackError(self.error)
                .map { $0.items }
        }).subscribe(onNext: { (items) in
            repositoryElements.accept(items)
        }).disposed(by: rx.disposeBag)

        keyword.asObservable().filterEmpty().flatMapLatest({ [weak self] (keyword) -> Observable<[User]> in
            guard let self = self else { return Observable.just([]) }
            return self.provider.searchUsers(query: keyword)
                .trackActivity(self.loading)
                .trackError(self.error)
                .map { $0.items }
        }).subscribe(onNext: { (items) in
            userElements.accept(items)
        }).disposed(by: rx.disposeBag)

        keyword.asDriver().throttle(3.0).drive(onNext: { (keyword) in
            if keyword.isNotEmpty {
                analytics.log(.search(keyword: keyword))
            }
        }).disposed(by: rx.disposeBag)

        Observable.just(()).flatMapLatest { () -> Observable<LanguageSection> in
            return self.provider.languages()
                .trackActivity(self.loading)
                .trackError(self.error)
            }.subscribe(onNext: { (item) in
                languageElements.accept(item)
            }).disposed(by: rx.disposeBag)

        let trendingTrigger = Observable.of(input.trigger, keyword.asObservable().map { $0.isEmpty }.filter { $0 == true }.mapToVoid()).merge()
        trendingTrigger.flatMapLatest { () -> Observable<[TrendingRepository]> in
            return self.provider.trendingRepositories(language: "", since: "daily")
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
            }.subscribe(onNext: { (items) in
                repositoryElements.accept(items.map { Repository(repo: $0) })
            }).disposed(by: rx.disposeBag)

        trendingTrigger.flatMapLatest { () -> Observable<[TrendingUser]> in
            return self.provider.trendingDevelopers(language: "", since: "daily")
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
            }.subscribe(onNext: { (items) in
                userElements.accept(items.map { User(user: $0) })
            }).disposed(by: rx.disposeBag)

        input.selection.drive(onNext: { (item) in
            switch item {
            case .repositoriesItem(let cellViewModel):
                repositorySelected.onNext(cellViewModel.repository)
            case .usersItem(let cellViewModel):
                userSelected.onNext(cellViewModel.user)
            }
        }).disposed(by: rx.disposeBag)

        Observable.combineLatest(repositoryElements, userElements, input.segmentSelection)
            .map { (repositories, users, segment) -> [SearchSection] in
                var elements: [SearchSection] = []
                let title = keyword.value.isEmpty ? "Trending" : ""
                switch segment {
                case .repositories:
                    let repositories = repositories.map({ (repository) -> SearchSectionItem in
                        let cellViewModel = RepositoryCellViewModel(with: repository)
                        return SearchSectionItem.repositoriesItem(cellViewModel: cellViewModel)
                    })
                    if repositories.isNotEmpty {
                        elements.append(SearchSection.repositories(title: title, items: repositories))
                    }
                case .users:
                    let users = users.map({ (user) -> SearchSectionItem in
                        let cellViewModel = UserCellViewModel(with: user)
                        return SearchSectionItem.usersItem(cellViewModel: cellViewModel)
                    })
                    if users.isNotEmpty {
                        elements.append(SearchSection.repositories(title: title, items: users))
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

        return Output(items: elements,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      repositorySelected: repositoryDetails,
                      userSelected: userDetails)
    }
}
