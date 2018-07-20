//
//  UserViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserViewModel: ViewModel, ViewModelType {

    struct Input {
        let detailsTrigger: Observable<Void>
        let imageSelection: Observable<Void>
        let openInWebSelection: Observable<Void>
        let repositoriesSelection: Observable<Void>
        let followersSelection: Observable<Void>
        let followingSelection: Observable<Void>
    }

    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<Error>

        let username: Driver<String>
        let fullname: Driver<String>
        let description: Driver<String>
        let imageUrl: Driver<URL?>
        let repositoriesCount: Driver<Int>
        let followersCount: Driver<Int>
        let followingCount: Driver<Int>
        let imageSelected: Driver<Void>
        let openInWebSelected: Driver<URL?>
        let repositoriesSelected: Driver<Void>
        let usersSelected: Driver<UsersViewModel>
    }

    let user: BehaviorRelay<User>

    init(user: User, provider: SwiftHubAPI) {
        self.user = BehaviorRelay(value: user)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        input.detailsTrigger.flatMapLatest { () -> Observable<User> in
            let user = self.user.value
            let owner = user.login ?? ""
            let request: Observable<User>
            switch user.type {
            case .user: request = self.provider.user(owner: owner)
            case .organization: request = self.provider.organization(owner: owner)
            }
            return request
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
        }.bind(to: user).disposed(by: rx.disposeBag)

        let username = user.map { $0.login ?? "" }.asDriverOnErrorJustComplete()
        let fullname = user.map { $0.name ?? "" }.asDriverOnErrorJustComplete()
        let description = user.map { $0.descriptionField ?? "" }.asDriverOnErrorJustComplete()
        let imageUrl = user.map { $0.avatarUrl?.url }.asDriverOnErrorJustComplete()
        let repositoriesCount = user.map { $0.publicRepos ?? 0 }.asDriverOnErrorJustComplete()
        let followersCount = user.map { $0.followers ?? 0 }.asDriverOnErrorJustComplete()
        let followingCount = user.map { $0.following ?? 0 }.asDriverOnErrorJustComplete()
        let imageSelected = input.imageSelection.asDriverOnErrorJustComplete()
        let openInWebSelected = input.openInWebSelection.map { () -> URL? in
            self.user.value.htmlUrl?.url
        }.asDriver(onErrorJustReturn: nil)

        let repositoriesSelected = input.repositoriesSelection.asDriver(onErrorJustReturn: ())

        let followersSelected = input.followersSelection.map { UsersMode.followers(user: self.user.value) }
        let followingSelected = input.followingSelection.map { UsersMode.following(user: self.user.value) }

        let usersSelected = Observable.of(followersSelected, followingSelected).merge()
            .asDriver(onErrorJustReturn: .followers(user: User()))
            .map { (mode) -> UsersViewModel in
                let viewModel = UsersViewModel(mode: mode, provider: self.provider)
                return viewModel
        }

        return Output(fetching: fetching,
                      error: errors,
                      username: username,
                      fullname: fullname,
                      description: description,
                      imageUrl: imageUrl,
                      repositoriesCount: repositoriesCount,
                      followersCount: followersCount,
                      followingCount: followingCount,
                      imageSelected: imageSelected,
                      openInWebSelected: openInWebSelected,
                      repositoriesSelected: repositoriesSelected,
                      usersSelected: usersSelected)
    }
}
