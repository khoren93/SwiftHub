//
//  IssueViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/5/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MessageKit

class IssueViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let userSelected: Observable<User>
        let mentionSelected: Observable<String>
    }

    struct Output {
        let userSelected: Observable<UserViewModel>
    }

    let repository: BehaviorRelay<Repository>
    let issue: BehaviorRelay<Issue>

    init(repository: Repository, issue: Issue, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        self.issue = BehaviorRelay(value: issue)
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

    func issueCommentsViewModel() -> IssueCommentsViewModel {
        let viewModel = IssueCommentsViewModel(repository: repository.value, issue: issue.value, provider: provider)
        return viewModel
    }
}
