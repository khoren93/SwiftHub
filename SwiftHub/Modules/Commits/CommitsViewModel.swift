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
    }

    let repository: BehaviorRelay<Repository>

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[CommitCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ () -> Observable<[CommitCellViewModel]> in
            self.page = 1
            let fullName = self.repository.value.fullName ?? ""
            return self.provider.commits(fullName: fullName, page: self.page)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
                .map { $0.map({ (commit) -> CommitCellViewModel in
                    let viewModel = CommitCellViewModel(with: commit)
                    return viewModel
                })}
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ () -> Observable<[CommitCellViewModel]> in
            self.page += 1
            let fullName = self.repository.value.fullName ?? ""
            return self.provider.commits(fullName: fullName, page: self.page)
                .trackActivity(self.loading)
                .trackActivity(self.footerLoading)
                .trackError(self.error)
                .map { $0.map({ (commit) -> CommitCellViewModel in
                    let viewModel = CommitCellViewModel(with: commit)
                    return viewModel
                })}
        })
            .map { elements.value + $0 }
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        let navigationTitle = repository.map({ (repository) -> String in
            return repository.fullName ?? ""
        }).asDriver(onErrorJustReturn: "")

        let commitSelected = input.selection.map { (cellViewModel) -> URL? in
            cellViewModel.commit.htmlUrl?.url
        }

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      commitSelected: commitSelected)
    }
}
