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
}

class UsersViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let selection: Driver<UserCellViewModel>
    }

    struct Output {
        let fetching: Driver<Bool>
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
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let elements = BehaviorRelay<[UserCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        let refresh = Observable.of(input.trigger.map { "" }.asObservable(), input.keywordTrigger.skip(1).throttle(1.5).distinctUntilChanged().asObservable()).merge()

        refresh.flatMapLatest({ (keyword) -> Observable<[UserCellViewModel]> in
            var request: Observable<[User]>
            switch self.mode.value {
            case .followers(let user): request = self.provider.userFollowers(username: user.login ?? "")
            case .following(let user): request = self.provider.userFollowing(username: user.login ?? "")
            }
            return request
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .map { $0.map { UserCellViewModel(with: $0) } }
        }).bind(to: elements).disposed(by: rx.disposeBag)

        let textDidBeginEditing = input.textDidBeginEditing

        let userDetails = input.selection.map({ (cellViewModel) -> UserViewModel in
            let user = cellViewModel.user
            let viewModel = UserViewModel(user: user, provider: self.provider)
            return viewModel
        })

        let navigationTitle = mode.map({ (mode) -> String in
            switch mode {
            case .followers: return "Followers"
            case .following: return "Following"
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .followers(let user): return user.avatarUrl?.url
            case .following(let user): return user.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(fetching: fetching,
                      navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      userSelected: userDetails,
                      error: errors)
    }
}
