//
//  EventsViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum EventsMode {
    case repository(repository: Repository)
    case userReceived(user: User)
    case userPerformed(user: User)
}

class EventsViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let selection: Driver<EventCellViewModel>
    }

    struct Output {
        let fetching: Driver<Bool>
        let headerFetching: Driver<Bool>
        let footerFetching: Driver<Bool>
        let navigationTitle: Driver<String>
        let imageUrl: Driver<URL?>
        let items: BehaviorRelay<[EventCellViewModel]>
        let userSelected: Driver<UserViewModel>
        let repositorySelected: Driver<RepositoryViewModel>
        let error: Driver<Error>
    }

    let mode: BehaviorRelay<EventsMode>

    init(mode: EventsMode, provider: SwiftHubAPI) {
        self.mode = BehaviorRelay(value: mode)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let headerActivityIndicator = ActivityIndicator()
        let footerActivityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let userSelected = PublishSubject<User>()

        let elements = BehaviorRelay<[EventCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ () -> Observable<[EventCellViewModel]> in
            self.page = 1
            return self.request()
                .trackActivity(activityIndicator)
                .trackActivity(headerActivityIndicator)
                .trackError(errorTracker)
                .map { $0.map({ (event) -> EventCellViewModel in
                    let viewModel = EventCellViewModel(with: event)
                    viewModel.userSelected.bind(to: userSelected).disposed(by: self.rx.disposeBag)
                    return viewModel
                })}
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ () -> Observable<[EventCellViewModel]> in
            self.page += 1
            return self.request()
                .trackActivity(activityIndicator)
                .trackActivity(footerActivityIndicator)
                .trackError(errorTracker)
                .map { $0.map { EventCellViewModel(with: $0) } }
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

        let repositoryDetails = input.selection.map { $0.event.repository }.filterNil()
            .map({ (repository) -> RepositoryViewModel in
                let viewModel = RepositoryViewModel(repository: repository, provider: self.provider)
                return viewModel
            })

        let navigationTitle = mode.map({ (mode) -> String in
            return "Events"
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .repository(let repository): return repository.owner?.avatarUrl?.url
            case .userReceived(let user): return user.avatarUrl?.url
            case .userPerformed(let user): return user.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(fetching: activityIndicator.asDriver(),
                      headerFetching: headerActivityIndicator.asDriver(),
                      footerFetching: footerActivityIndicator.asDriver(),
                      navigationTitle: navigationTitle,
                      imageUrl: imageUrl,
                      items: elements,
                      userSelected: userDetails,
                      repositorySelected: repositoryDetails,
                      error: errorTracker.asDriver())
    }

    func request() -> Observable<[Event]> {
        var request: Observable<[Event]>
        switch self.mode.value {
        case .repository(let repository):
            request = self.provider.repositoryEvents(owner: repository.owner?.login ?? "", repo: repository.name ?? "", page: self.page)
        case .userReceived(let user):
            request = self.provider.userReceivedEvents(username: user.login ?? "", page: self.page)
        case .userPerformed(let user):
            request = self.provider.userPerformedEvents(username: user.login ?? "", page: self.page)
        }
        return request
    }
}
