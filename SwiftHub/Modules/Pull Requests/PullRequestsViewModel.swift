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
        let pullRequestSelected: Driver<PullRequestViewModel>
        let userSelected: Driver<UserViewModel>
    }

    let repository: BehaviorRelay<Repository>
    let segment = BehaviorRelay<PullRequestSegments>(value: .open)
    let userSelected = PublishSubject<User>()

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[PullRequestCellViewModel]>(value: [])

        input.segmentSelection.bind(to: segment).disposed(by: rx.disposeBag)

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[PullRequestCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[PullRequestCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(elements.value + items)
            }).disposed(by: rx.disposeBag)

        let navigationTitle = repository.map({ (repository) -> String in
            return repository.fullname ?? ""
        }).asDriver(onErrorJustReturn: "")

        let pullRequestSelected = input.selection.map { (cellViewModel) -> PullRequestViewModel in
            let viewModel = PullRequestViewModel(repository: self.repository.value, pullRequest: cellViewModel.pullRequest, provider: self.provider)
            return viewModel
        }

        let userDetails = userSelected.asDriver(onErrorJustReturn: User())
            .map({ (user) -> UserViewModel in
                let viewModel = UserViewModel(user: user, provider: self.provider)
                return viewModel
            })

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      pullRequestSelected: pullRequestSelected,
                      userSelected: userDetails)
    }

    func request() -> Observable<[PullRequestCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        let state = segment.value.state.rawValue
        return provider.pullRequests(fullname: fullname, state: state, page: page)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (pullRequest) -> PullRequestCellViewModel in
                let viewModel = PullRequestCellViewModel(with: pullRequest)
                viewModel.userSelected.bind(to: self.userSelected).disposed(by: self.rx.disposeBag)
                return viewModel
            })}
    }
}
