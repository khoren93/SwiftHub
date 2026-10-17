//
//  HomeTabBarViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/11/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class HomeTabBarViewModel: ViewModel, ViewModelType {

    struct Input {
    }

    struct Output {
        let tabBarItems: Driver<[HomeTabBarItem]>
    }

    let authorized: Bool

    init(authorized: Bool, provider: SwiftHubAPI) {
        self.authorized = authorized
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let tabBarItems = Observable.just(authorized).map { (authorized) -> [HomeTabBarItem] in
            if authorized {
                return [.news, .search, .notifications, .settings]
            } else {
                return [.search, .login, .settings]
            }
        }.asDriver(onErrorJustReturn: [])

        return Output(tabBarItems: tabBarItems)
    }

    func viewModel(for tabBarItem: HomeTabBarItem) -> ViewModel {
        switch tabBarItem {
        case .search:
            let viewModel = SearchViewModel(provider: provider)
            return viewModel
        case .news:
            let user = User.currentUser()!
            let viewModel = EventsViewModel(mode: .user(user: user), provider: provider)
            return viewModel
        case .notifications:
            let viewModel = NotificationsViewModel(mode: .mine, provider: provider)
            return viewModel
        case .settings:
            let viewModel = SettingsViewModel(provider: provider)
            return viewModel
        case .login:
            let viewModel = LoginViewModel(provider: provider)
            return viewModel
        }
    }
}
