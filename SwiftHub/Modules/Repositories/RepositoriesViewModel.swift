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
    case userWatchingRepositories(user: User)

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
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[RepositoryCellViewModel]>
        let imageUrl: Driver<URL?>
        let textDidBeginEditing: Driver<Void>
        let dismissKeyboard: Driver<Void>
        let repositorySelected: Driver<RepositoryViewModel>
    }

    let mode: BehaviorRelay<RepositoriesMode>

    init(mode: RepositoriesMode, provider: SwiftHubAPI) {
        self.mode = BehaviorRelay(value: mode)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[RepositoryCellViewModel]>(value: [])
        let dismissKeyboard = input.selection.mapToVoid()

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[RepositoryCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page = 1
            return self.request()
                .trackActivity(self.headerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ [weak self] () -> Observable<[RepositoryCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            self.page += 1
            return self.request()
                .trackActivity(self.footerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(elements.value + items)
        }).disposed(by: rx.disposeBag)

        let textDidBeginEditing = input.textDidBeginEditing

        let repositoryDetails = input.selection.map({ (cellViewModel) -> RepositoryViewModel in
            let repository = cellViewModel.repository
            let viewModel = RepositoryViewModel(repository: repository, provider: self.provider)
            return viewModel
        })

        let navigationTitle = mode.map({ (mode) -> String in
            switch mode {
            case .userRepositories: return R.string.localizable.repositoriesRepositoriesNavigationTitle.key.localized()
            case .userStarredRepositories: return R.string.localizable.repositoriesStarredNavigationTitle.key.localized()
            case .userWatchingRepositories: return "Watching"
            case .forks: return R.string.localizable.repositoriesForksNavigationTitle.key.localized()
            }
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .userRepositories(let user),
                 .userStarredRepositories(let user),
                 .userWatchingRepositories(let user):
                return user.avatarUrl?.url
            case .forks(let repository):
                return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      imageUrl: imageUrl,
                      textDidBeginEditing: textDidBeginEditing,
                      dismissKeyboard: dismissKeyboard,
                      repositorySelected: repositoryDetails)
    }

    func request() -> Observable<[RepositoryCellViewModel]> {
        var request: Single<[Repository]>
        switch self.mode.value {
        case .userRepositories(let user):
            request = provider.userRepositories(username: user.login ?? "", page: page)
        case .userStarredRepositories(let user):
            request = provider.userStarredRepositories(username: user.login ?? "", page: page)
        case .userWatchingRepositories(let user):
            request = provider.userWatchingRepositories(username: user.login ?? "", page: page)
        case .forks(let repository):
            request = provider.forks(fullname: repository.fullname ?? "", page: page)
        }
        return request
            .trackActivity(loading)
            .trackError(error)
            .map { $0.map { RepositoryCellViewModel(with: $0) } }
    }
}
