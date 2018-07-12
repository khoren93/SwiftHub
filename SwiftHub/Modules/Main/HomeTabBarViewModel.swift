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

    struct Input { }

    struct Output {
        let tabBarItems: Driver<[HomeTabBarItem]>
    }

    let loggedIn = BehaviorRelay<Bool>(value: false)

    func transform(input: Input) -> Output {

        let tabBarItems = loggedIn.map { (loggedIn) -> [HomeTabBarItem] in
            if loggedIn {
                return [.search, .news, .profile, .notifications, .settings]
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
            let viewModel = ViewModel(provider: provider)
            return viewModel
        case .profile:
            let viewModel = ViewModel(provider: provider)
            return viewModel
        case .notifications:
            let viewModel = ViewModel(provider: provider)
            return viewModel
        case .settings:
            let viewModel = SettingsViewModel(provider: provider)
            return viewModel
        case .login:
            let viewModel = LoginViewModel(provider: provider)
            viewModel.loginEvent.bind(to: loggedIn).disposed(by: rx.disposeBag)
            return viewModel
        }
    }
}
