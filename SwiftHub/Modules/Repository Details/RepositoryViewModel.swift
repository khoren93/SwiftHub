//
//  RepositoryViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RepositoryViewModel: ViewModel, ViewModelType {

    struct Input {
        let detailsTrigger: Observable<Void>
    }

    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<Error>

        let name: Driver<String>
        let description: Driver<String>
        let imageUrl: Driver<URL?>
    }

    let repository: BehaviorRelay<Repository>

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        input.detailsTrigger.flatMapLatest { () -> Observable<Repository> in
            let owner = self.repository.value.owner?.login ?? ""
            let repo = self.repository.value.name ?? ""
            return self.provider.repository(owner: owner, repo: repo)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
        }.bind(to: repository).disposed(by: rx.disposeBag)

        let name = repository.map { $0.name ?? "" }.asDriverOnErrorJustComplete()
        let description = repository.map { $0.descriptionField ?? "" }.asDriverOnErrorJustComplete()
        let imageUrl = repository.map { $0.owner?.avatarUrl?.url }.asDriverOnErrorJustComplete()

        return Output(fetching: fetching,
                      error: errors,
                      name: name,
                      description: description,
                      imageUrl: imageUrl)
    }
}
