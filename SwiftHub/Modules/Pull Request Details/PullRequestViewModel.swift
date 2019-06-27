//
//  PullRequestViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/12/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MessageKit

class PullRequestViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let userSelected: Observable<User>
        let mentionSelected: Observable<String>
    }

    struct Output {
        let userSelected: Observable<UserViewModel>
    }

    let repository: BehaviorRelay<Repository>
    let pullRequest: BehaviorRelay<PullRequest>

    init(repository: Repository, pullRequest: PullRequest, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        self.pullRequest = BehaviorRelay(value: pullRequest)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let userSelected = Observable.of(input.userSelected, input.mentionSelected.map({ (mention) -> User in
            var user = User()
            user.login = mention.removingPrefix("@")
            return user
        }) ).merge()
            .map { (user) -> UserViewModel in
                let viewModel = UserViewModel(user: user, provider: self.provider)
                return viewModel
        }

        return Output(userSelected: userSelected)
    }

    func pullRequestCommentsViewModel() -> PullRequestCommentsViewModel {
        let viewModel = PullRequestCommentsViewModel(repository: repository.value, pullRequest: pullRequest.value, provider: provider)
        return viewModel
    }
}
