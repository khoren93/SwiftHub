//
//  RepositoryViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RepositoryViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let imageSelection: Observable<Void>
        let openInWebSelection: Observable<Void>
        let watchersSelection: Observable<Void>
        let starsSelection: Observable<Void>
        let forksSelection: Observable<Void>
    }

    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<Error>

        let name: Driver<String>
        let description: Driver<String>
        let imageUrl: Driver<URL?>
        let watchersCount: Driver<Int>
        let starsCount: Driver<Int>
        let forksCount: Driver<Int>
        let imageSelected: Driver<UserViewModel>
        let openInWebSelected: Driver<URL?>
        let usersSelected: Driver<UsersViewModel>
    }

    let repository: BehaviorRelay<Repository>

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        input.headerRefresh.flatMapLatest { () -> Observable<Repository> in
            let owner = self.repository.value.owner?.login ?? ""
            let repo = self.repository.value.name ?? ""
            return self.provider.repository(owner: owner, repo: repo)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
        }.bind(to: repository).disposed(by: rx.disposeBag)

        let name = repository.map { $0.fullName ?? "" }.asDriverOnErrorJustComplete()
        let description = repository.map { $0.descriptionField ?? "" }.asDriverOnErrorJustComplete()
        let watchersCount = repository.map { $0.subscribersCount ?? 0 }.asDriverOnErrorJustComplete()
        let starsCount = repository.map { $0.stargazersCount ?? 0 }.asDriverOnErrorJustComplete()
        let forksCount = repository.map { $0.forks ?? 0 }.asDriverOnErrorJustComplete()
        let imageUrl = repository.map { $0.owner?.avatarUrl?.url }.asDriverOnErrorJustComplete()

        let imageSelected = input.imageSelection.asDriver(onErrorJustReturn: ())
            .map { () -> UserViewModel in
                let user = self.repository.value.owner ?? User()
                let viewModel = UserViewModel(user: user, provider: self.provider)
                return viewModel
        }

        let openInWebSelected = input.openInWebSelection.map { () -> URL? in
            self.repository.value.htmlUrl?.url
        }.asDriver(onErrorJustReturn: nil)

        let watchersSelected = input.watchersSelection.map { UsersMode.watchers(repository: self.repository.value) }
        let starsSelected = input.starsSelection.map { UsersMode.stars(repository: self.repository.value) }
        let forksSelected = input.forksSelection.map { UsersMode.forks(repository: self.repository.value) }

        let usersSelected = Observable.of(watchersSelected, starsSelected, forksSelected).merge()
            .asDriver(onErrorJustReturn: .followers(user: User()))
            .map { (mode) -> UsersViewModel in
                let viewModel = UsersViewModel(mode: mode, provider: self.provider)
                return viewModel
        }

        return Output(fetching: fetching,
                      error: errors,
                      name: name,
                      description: description,
                      imageUrl: imageUrl,
                      watchersCount: watchersCount,
                      starsCount: starsCount,
                      forksCount: forksCount,
                      imageSelected: imageSelected,
                      openInWebSelected: openInWebSelected,
                      usersSelected: usersSelected)
    }
}
