//
//  IssuesViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class IssuesViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let segmentSelection: Observable<IssueSegments>
        let selection: Driver<IssueCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let imageUrl: Driver<URL?>
        let items: BehaviorRelay<[IssueCellViewModel]>
        let userSelected: Driver<UserViewModel>
        let issueSelected: Driver<IssueViewModel>
    }

    let repository: BehaviorRelay<Repository>
    let segment = BehaviorRelay<IssueSegments>(value: .open)
    let userSelected = PublishSubject<User>()

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
        if let fullname = repository.fullname {
            analytics.log(.issues(fullname: fullname))
        }
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[IssueCellViewModel]>(value: [])

        input.segmentSelection.bind(to: segment).disposed(by: rx.disposeBag)

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[IssueCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[IssueCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(elements.value + items)
            }).disposed(by: rx.disposeBag)

        let userDetails = userSelected.asDriver(onErrorJustReturn: User())
            .map({ (user) -> UserViewModel in
                let viewModel = UserViewModel(user: user, provider: self.provider)
                return viewModel
            })

        let navigationTitle = repository.map({ (mode) -> String in
            return R.string.localizable.eventsNavigationTitle.key.localized()
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = repository.map({ (repository) -> URL? in
            repository.owner?.avatarUrl?.url
        }).asDriver(onErrorJustReturn: nil)

        let issueSelected = input.selection.map { (cellViewModel) -> IssueViewModel in
            let viewModel = IssueViewModel(repository: self.repository.value, issue: cellViewModel.issue, provider: self.provider)
            return viewModel
        }

        return Output(navigationTitle: navigationTitle,
                      imageUrl: imageUrl,
                      items: elements,
                      userSelected: userDetails,
                      issueSelected: issueSelected)
    }

    func request() -> Observable<[IssueCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        let state = segment.value.state.rawValue
        return provider.issues(fullname: fullname, state: state, page: page)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (issue) -> IssueCellViewModel in
                let viewModel = IssueCellViewModel(with: issue)
                viewModel.userSelected.bind(to: self.userSelected).disposed(by: self.rx.disposeBag)
                return viewModel
            })
        }
    }
}
