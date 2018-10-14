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

        let repositorySelected = PublishSubject<Repository>()
        let userSelected = PublishSubject<User>()

        let dismissKeyboard = input.selection.mapToVoid()

        let refresh = Observable.of(input.keywordTrigger.skip(1).throttle(0.5).distinctUntilChanged().asObservable()).merge()

        refresh.flatMapLatest({ (keyword) -> Observable<[Repository]> in
            guard keyword.isNotEmpty else {
                return Observable.just([])
            }
            return self.provider.searchRepositories(query: keyword)
                .trackActivity(self.loading)
                .trackError(self.error)
                .map { $0.items }
        }).subscribe(onNext: { (items) in
            repositoryElements.accept(items)
        }).disposed(by: rx.disposeBag)

        refresh.flatMapLatest({ (keyword) -> Observable<[User]> in
            guard keyword.isNotEmpty else {
                return Observable.just([])
            }
            return self.provider.searchUsers(query: keyword)
                .trackActivity(self.loading)
                .trackError(self.error)
                .map { $0.items }
        }).subscribe(onNext: { (items) in
            userElements.accept(items)
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
                switch segment {
                case .repositories:
                    let repositories = repositories.map({ (repository) -> SearchSectionItem in
                        let cellViewModel = RepositoryCellViewModel(with: repository)
                        return SearchSectionItem.repositoriesItem(cellViewModel: cellViewModel)
                    })
                    if repositories.isNotEmpty {
                        elements.append(SearchSection.repositories(title: "", items: repositories))
                    }
                case .users:
                    let users = users.map({ (user) -> SearchSectionItem in
                        let cellViewModel = UserCellViewModel(with: user)
                        return SearchSectionItem.usersItem(cellViewModel: cellViewModel)
                    })
                    if users.isNotEmpty {
                        elements.append(SearchSection.repositories(title: "", items: users))
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
