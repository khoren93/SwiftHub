//
//  PullRequestsViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PullRequestsViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let segmentSelection: Observable<PullRequestSegments>
        let selection: Driver<PullRequestCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[PullRequestCellViewModel]>
        let pullRequestSelected: Driver<URL?>
    }

    let repository: BehaviorRelay<Repository>
    let segment = BehaviorRelay<PullRequestSegments>(value: .open)

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[PullRequestCellViewModel]>(value: [])

        input.segmentSelection.bind(to: segment).disposed(by: rx.disposeBag)

        input.headerRefresh.flatMapLatest({ () -> Observable<[PullRequestCellViewModel]> in
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ () -> Observable<[PullRequestCellViewModel]> in
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .map { elements.value + $0 }
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        let navigationTitle = repository.map({ (repository) -> String in
            return repository.fullName ?? ""
        }).asDriver(onErrorJustReturn: "")

        let pullRequestSelected = input.selection.map { (cellViewModel) -> URL? in
            cellViewModel.pullRequest.htmlUrl?.url
        }

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      pullRequestSelected: pullRequestSelected)
    }

    func request() -> Observable<[PullRequestCellViewModel]> {
        let fullname = repository.value.fullName ?? ""
        let state = segment.value.state.rawValue
        return provider.pullRequests(fullName: fullname, state: state, page: page)
            .trackActivity(self.loading)
            .trackError(self.error)
            .map { $0.map({ (pullRequest) -> PullRequestCellViewModel in
                let viewModel = PullRequestCellViewModel(with: pullRequest)
                return viewModel
            })}
    }
}
