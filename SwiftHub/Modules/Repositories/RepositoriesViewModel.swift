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

    case forks(repository: Repository)
}

class RepositoriesViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let keywordTrigger: Driver<String>
        let textDidBeginEditing: Driver<Void>
        let selection: Driver<RepositoryCellViewModel>
    }

    struct Output {
        let fetching: Driver<Bool>
        let headerFetching: Driver<Bool>
        let footerFetching: Driver<Bool>
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
        let headerActivityIndicator = ActivityIndicator()
        let footerActivityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let elements = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        input.headerRefresh.flatMapLatest({ () -> Observable<[RepositoryCellViewModel]> in
            self.page = 1
            return self.request()
                .trackActivity(activityIndicator)
                .trackActivity(headerActivityIndicator)
                .trackError(errorTracker)
        }).bind(to: elements).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ () -> Observable<[RepositoryCellViewModel]> in
            self.page += 1
            return self.request()
                .trackActivity(activityIndicator)
                .trackActivity(footerActivityIndicator)
                .trackError(errorTracker)
        }).map { elements.value + $0 }.bind(to: elements).disposed(by: rx.disposeBag)

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
            case .forks: return "Forks"
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .userRepositories(let user): return user.avatarUrl?.url
            case .userStarredRepositories(let user): return user.avatarUrl?.url
            case .forks(let repository): return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(fetching: activityIndicator.asDriver(),
                      headerFetching: headerActivityIndicator.asDriver(),
                      footerFetching: footerActivityIndicator.asDriver(),
                      navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      repositorySelected: repositoryDetails,
                      error: errorTracker.asDriver())
    }

    func request() -> Observable<[RepositoryCellViewModel]> {
        var request: Observable<[Repository]>
        switch self.mode.value {
        case .userRepositories(let user):
            request = self.provider.userRepositories(username: user.login ?? "", page: self.page)
        case .userStarredRepositories(let user):
            request = self.provider.userStarredRepositories(username: user.login ?? "", page: self.page)
        case .forks(let repository):
            request = self.provider.forks(owner: repository.owner?.login ?? "", repo: repository.name ?? "", page: self.page)
        }
        return request.map { $0.map { RepositoryCellViewModel(with: $0) } }
    }
}
