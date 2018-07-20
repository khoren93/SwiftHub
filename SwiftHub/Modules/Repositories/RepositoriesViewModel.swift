//
//  RepositoriesViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum RepositoriesMode {
    case userRepositories(user: User)
    case userStarredRepositories(user: User)
}

class RepositoriesViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let selection: Driver<RepositoryCellViewModel>
    }

    struct Output {
        let fetching: Driver<Bool>
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[RepositoryCellViewModel]>
        let imageUrl: Driver<URL?>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let repositorySelected: Driver<RepositoryViewModel>
        let error: Driver<Error>
    }

    let mode: BehaviorRelay<RepositoriesMode>

    init(mode: RepositoriesMode, provider: SwiftHubAPI) {
        self.mode = BehaviorRelay(value: mode)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let elements = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        let refresh = Observable.of(input.trigger.map { "" }.asObservable(), input.keywordTrigger.skip(1).throttle(1.5).distinctUntilChanged().asObservable()).merge()

        refresh.flatMapLatest({ (keyword) -> Observable<[RepositoryCellViewModel]> in
            var request: Observable<[Repository]>
            switch self.mode.value {
            case .userRepositories(let user): request = self.provider.userRepositories(username: user.login ?? "")
            case .userStarredRepositories(let user): request = self.provider.userStarredRepositories(username: user.login ?? "")
            }
            return request
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .map { $0.map { RepositoryCellViewModel(with: $0) } }
        }).bind(to: elements).disposed(by: rx.disposeBag)

        let textDidBeginEditing = input.textDidBeginEditing

        let repositoryDetails = input.selection.map({ (cellViewModel) -> RepositoryViewModel in
            let repository = cellViewModel.repository
            let viewModel = RepositoryViewModel(repository: repository, provider: self.provider)
            return viewModel
        })

        let navigationTitle = mode.map({ (mode) -> String in
            switch mode {
            case .userRepositories: return "Repositories"
            case .userStarredRepositories: return "Starred"
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .userRepositories(let user): return user.avatarUrl?.url
            case .userStarredRepositories(let user): return user.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(fetching: fetching,
                      navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      repositorySelected: repositoryDetails,
                      error: errors)
    }
}
