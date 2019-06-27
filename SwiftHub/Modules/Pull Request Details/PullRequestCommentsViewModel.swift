//
//  PullRequestCommentsViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/12/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import MessageKit

class PullRequestCommentsViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let sendSelected: Observable<String>
    }

    struct Output {
        let items: Observable<[Comment]>
    }

    let repository: BehaviorRelay<Repository>
    let pullRequest: BehaviorRelay<PullRequest>

    init(repository: Repository, pullRequest: PullRequest, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        self.pullRequest = BehaviorRelay(value: pullRequest)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let comments = input.headerRefresh.flatMapLatest { () -> Observable<[Comment]> in
            let fullname = self.repository.value.fullname ?? ""
            let issueNumber = self.pullRequest.value.number ?? 0
            return self.provider.issueComments(fullname: fullname, number: issueNumber, page: self.page)
                .trackActivity(self.loading)
                .trackError(self.error)
        }

        input.sendSelected.subscribe(onNext: { (text) in
            logDebug(text)
        }).disposed(by: rx.disposeBag)

        return Output(items: comments)
    }
}
