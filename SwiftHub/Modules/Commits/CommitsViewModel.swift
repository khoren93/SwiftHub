//
//  CommitsViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CommitsViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<CommitCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[CommitCellViewModel]>
        let commitSelected: Driver<URL?>
        let userSelected: Driver<UserViewModel>
    }

    let repository: BehaviorRelay<Repository>
    let userSelected = PublishSubject<User>()

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let elements = BehaviorRelay<[CommitCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[CommitCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[CommitCellViewModel]> in
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

        let commitSelected = input.selection.map { (cellViewModel) -> URL? in
            cellViewModel.commit.htmlUrl?.url
        }

        let userDetails = userSelected.asDriver(onErrorJustReturn: User())
            .map({ (user) -> UserViewModel in
                let viewModel = UserViewModel(user: user, provider: self.provider)
                return viewModel
            })

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      commitSelected: commitSelected,
                      userSelected: userDetails)
    }

    func request() -> Observable<[CommitCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        return provider.commits(fullname: fullname, page: page)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map({ (commit) -> CommitCellViewModel in
                let viewModel = CommitCellViewModel(with: commit)
                viewModel.userSelected.bind(to: self.userSelected).disposed(by: self.rx.disposeBag)
                return viewModel
            })}
    }
}
