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
        let fetching: Driver<Bool>
        let headerFetching: Driver<Bool>
        let footerFetching: Driver<Bool>
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[UserCellViewModel]>
        let imageUrl: Driver<URL?>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let userSelected: Driver<UserViewModel>
        let error: Driver<Error>
    }

    let mode: BehaviorRelay<UsersMode>

    init(mode: UsersMode, provider: SwiftHubAPI) {
        self.mode = BehaviorRelay(value: mode)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let headerActivityIndicator = ActivityIndicator()
        let footerActivityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let elements = BehaviorRelay<[UserCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        input.headerRefresh.flatMapLatest({ () -> Observable<[UserCellViewModel]> in
            self.page = 1
            return self.request()
                .trackActivity(activityIndicator)
                .trackActivity(headerActivityIndicator)
                .trackError(errorTracker)
                .map { $0.map { UserCellViewModel(with: $0) } }
        }).bind(to: elements).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ () -> Observable<[UserCellViewModel]> in
            self.page += 1
            return self.request()
                .trackActivity(activityIndicator)
                .trackActivity(footerActivityIndicator)
                .trackError(errorTracker)
                .map { $0.map { UserCellViewModel(with: $0) } }
        }).map { elements.value + $0 }.bind(to: elements).disposed(by: rx.disposeBag)

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
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .followers(let user): return user.avatarUrl?.url
            case .following(let user): return user.avatarUrl?.url
            case .watchers(let repository): return repository.owner?.avatarUrl?.url
            case .stars(let repository): return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(fetching: activityIndicator.asDriver(),
                      headerFetching: headerActivityIndicator.asDriver(),
                      footerFetching: footerActivityIndicator.asDriver(),
                      navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      userSelected: userDetails,
                      error: errorTracker.asDriver())
    }

    func request() -> Observable<[User]> {
        var request: Observable<[User]>
        switch self.mode.value {
        case .followers(let user):
            request = self.provider.userFollowers(username: user.login ?? "", page: self.page)
        case .following(let user):
            request = self.provider.userFollowing(username: user.login ?? "", page: self.page)
        case .watchers(let repository):
            request = self.provider.watchers(fullName: repository.fullName ?? "", page: self.page)
        case .stars(let repository):
            request = self.provider.stargazers(fullName: repository.fullName ?? "", page: self.page)
        }
        return request
    }
}
