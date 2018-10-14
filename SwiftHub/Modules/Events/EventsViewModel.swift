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
    case user(user: User)
}

class EventsViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let segmentSelection: Observable<EventSegments>
        let selection: Driver<EventCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let imageUrl: Driver<URL?>
        let items: BehaviorRelay<[EventCellViewModel]>
        let userSelected: Driver<UserViewModel>
        let repositorySelected: Driver<RepositoryViewModel>
    }

    let mode: BehaviorRelay<EventsMode>
    let segment = BehaviorRelay<EventSegments>(value: .received)

    init(mode: EventsMode, provider: SwiftHubAPI) {
        self.mode = BehaviorRelay(value: mode)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let userSelected = PublishSubject<User>()
        let elements = BehaviorRelay<[EventCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ () -> Observable<[EventCellViewModel]> in
            self.page = 1
            return self.request()
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
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
                .trackActivity(self.loading)
                .trackActivity(self.footerLoading)
                .trackError(self.error)
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
            return R.string.localizable.eventsNavigationTitle.key.localized()
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .repository(let repository): return repository.owner?.avatarUrl?.url
            case .user(let user): return user.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        input.segmentSelection.bind(to: segment).disposed(by: rx.disposeBag)

        return Output(navigationTitle: navigationTitle,
                      imageUrl: imageUrl,
                      items: elements,
                      userSelected: userDetails,
                      repositorySelected: repositoryDetails)
    }

    func request() -> Observable<[Event]> {
        var request: Observable<[Event]>
        switch self.mode.value {
        case .repository(let repository):
            request = self.provider.repositoryEvents(owner: repository.owner?.login ?? "", repo: repository.name ?? "", page: self.page)
        case .user(let user):
            switch self.segment.value {
            case .performed:
                request = self.provider.userPerformedEvents(username: user.login ?? "", page: self.page)
            case .received:
                request = self.provider.userReceivedEvents(username: user.login ?? "", page: self.page)
            }
        }
        return request
    }
}
