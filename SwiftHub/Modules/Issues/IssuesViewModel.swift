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
        let issueSelected: Driver<URL?>
    }

    let repository: BehaviorRelay<Repository>
    let segment = BehaviorRelay<IssueSegments>(value: .open)

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
        if let fullName = repository.fullName {
            analytics.log(.issues(fullname: fullName))
        }
    }

    func transform(input: Input) -> Output {
        let userSelected = PublishSubject<User>()
        let elements = BehaviorRelay<[IssueCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ () -> Observable<[IssueCellViewModel]> in
            self.page = 1
            return self.request()
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
                .map { $0.map({ (issue) -> IssueCellViewModel in
                    let viewModel = IssueCellViewModel(with: issue)
                    viewModel.userSelected.bind(to: userSelected).disposed(by: self.rx.disposeBag)
                    return viewModel
                })
            }
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ () -> Observable<[IssueCellViewModel]> in
            self.page += 1
            return self.request()
                .trackActivity(self.loading)
                .trackActivity(self.footerLoading)
                .trackError(self.error)
                .map { $0.map({ (issue) -> IssueCellViewModel in
                    let viewModel = IssueCellViewModel(with: issue)
                    viewModel.userSelected.bind(to: userSelected).disposed(by: self.rx.disposeBag)
                    return viewModel
                })
            }
        })
            .map { elements.value + $0 }
            .subscribe(onNext: { (items) in
                elements.accept(items)
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

        input.segmentSelection.bind(to: segment).disposed(by: rx.disposeBag)

        let issueSelected = input.selection.map { (cellViewModel) -> URL? in
            cellViewModel.issue.htmlUrl?.url
        }

        return Output(navigationTitle: navigationTitle,
                      imageUrl: imageUrl,
                      items: elements,
                      userSelected: userDetails,
                      issueSelected: issueSelected)
    }

    func request() -> Observable<[Issue]> {
        let fullname = repository.value.fullName ?? ""
        let state = segment.value.state.rawValue
        return provider.repositoryIssues(fullName: fullname, state: state, page: page)
    }
}
