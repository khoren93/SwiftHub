//
//  NotificationsViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 9/19/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

enum NotificationsMode {
    case mine
    case repository(repository: Repository)
}

class NotificationsViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let footerRefresh: Observable<Void>
        let segmentSelection: Observable<NotificationSegments>
        let selection: Driver<NotificationCellViewModel>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let imageUrl: Driver<URL?>
        let items: BehaviorRelay<[NotificationCellViewModel]>
        let userSelected: Driver<UserViewModel>
        let repositorySelected: Driver<RepositoryViewModel>
    }

    let mode: BehaviorRelay<NotificationsMode>
    let all = BehaviorRelay(value: false)
    let participating = BehaviorRelay(value: false)

    init(mode: NotificationsMode, provider: SwiftHubAPI) {
        self.mode = BehaviorRelay(value: mode)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let userSelected = PublishSubject<User>()

        input.segmentSelection.map { $0 == .all }.bind(to: all).disposed(by: rx.disposeBag)
        input.segmentSelection.map { $0 == .participating }.bind(to: participating).disposed(by: rx.disposeBag)

        let elements = BehaviorRelay<[NotificationCellViewModel]>(value: [])

        let refresh = Observable.of(input.headerRefresh, input.segmentSelection.mapToVoid()).merge()
        refresh.flatMapLatest({ () -> Observable<[NotificationCellViewModel]> in
            self.page = 1
            return self.request()
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
                .map { $0.map({ (event) -> NotificationCellViewModel in
                    let viewModel = NotificationCellViewModel(with: event)
                    viewModel.userSelected.bind(to: userSelected).disposed(by: self.rx.disposeBag)
                    return viewModel
                })}
        })
            .subscribe(onNext: { (items) in
                elements.accept(items)
            }).disposed(by: rx.disposeBag)

        input.footerRefresh.flatMapLatest({ () -> Observable<[NotificationCellViewModel]> in
            self.page += 1
            return self.request()
                .trackActivity(self.loading)
                .trackActivity(self.footerLoading)
                .trackError(self.error)
                .map { $0.map { NotificationCellViewModel(with: $0) } }
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

        let repositoryDetails = input.selection.map { $0.notification.repository }.filterNil()
            .map({ (repository) -> RepositoryViewModel in
                let viewModel = RepositoryViewModel(repository: repository, provider: self.provider)
                return viewModel
            })

        let navigationTitle = mode.map({ (mode) -> String in
            return "Notifications"
        }).asDriver(onErrorJustReturn: "")

        let imageUrl = mode.map({ (mode) -> URL? in
            switch mode {
            case .mine: return nil
            case .repository(let repository): return repository.owner?.avatarUrl?.url
            }
        }).asDriver(onErrorJustReturn: nil)

        return Output(navigationTitle: navigationTitle,
                      imageUrl: imageUrl,
                      items: elements,
                      userSelected: userDetails,
                      repositorySelected: repositoryDetails)
    }

    func request() -> Observable<[Notification]> {
        var request: Observable<[Notification]>
        switch self.mode.value {
        case .mine:
            request = self.provider.notifications(all: all.value, participating: participating.value, page: self.page)
        case .repository(let repository):
            request = self.provider.repositoryNotifications(fullName: repository.fullName ?? "", all: all.value, participating: participating.value, page: self.page)
        }
        return request
    }
}
