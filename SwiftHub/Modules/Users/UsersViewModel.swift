//
//  UsersViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum UsersMode {
    case followers(user: User)
    case following(user: User)

    case watchers(repository: Repository)
    case stars(repository: Repository)
    case contributors(repository: Repository)
}

class UsersViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let selection: Driver<UserCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[UserCellViewModel]>
        let imageUrl: Driver<URL?>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let userSelected: Driver<UserViewModel>
    }

    let mode: BehaviorRelay<UsersMode>

    init(mode: UsersMode, provider: SwiftHubAPI) {
        self.mode = BehaviorRelay(value: mode)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[UserCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[UserCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[UserCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(elements.value + items)
        }).disposed(by: rx.disposeBag)

        let textDidBeginEditing = input.textDidBeginEditing

        let userDetails = input.selection.map({ (cellViewModel) -> UserViewModel in
            let user = cellViewModel.user
            let viewModel = UserViewModel(user: user, provider: self.provider)
            return viewModel
        })

        let navigationTitle = mode.map({ (mode) -> String in
            switch mode {
            case .followers: return R.string.localizable.usersFollowersNavigationTitle.key.localized()
            case .following: return R.string.localizable.usersFollowingNavigationTitle.key.localized()
            case .watchers: return R.string.localizable.usersWatchersNavigationTitle.key.localized()
            case .stars: return R.string.localizable.usersStargazersNavigationTitle.key.localized()
            case .contributors: return R.string.localizable.usersContributorsNavigationTitle.key.localized()
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .followers(let user),
                 .following(let user):
                return user.avatarUrl?.url
            case .watchers(let repository),
                 .stars(let repository),
                 .contributors(let repository):
                return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      userSelected: userDetails)
    }

    func request() -> Observable<[UserCellViewModel]> {
        var request: Single<[User]>
        switch self.mode.value {
        case .followers(let user):
            request = provider.userFollowers(username: user.login ?? "", page: page)
        case .following(let user):
            request = provider.userFollowing(username: user.login ?? "", page: page)
        case .watchers(let repository):
            request = provider.watchers(fullname: repository.fullname ?? "", page: page)
        case .stars(let repository):
            request = provider.stargazers(fullname: repository.fullname ?? "", page: page)
        case .contributors(let repository):
            request = provider.contributors(fullname: repository.fullname ?? "", page: page)
        }
        return request
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map { UserCellViewModel(with: $0) } }
    }
}
