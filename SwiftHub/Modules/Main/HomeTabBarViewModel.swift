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
import RxDataSources

class HomeTabBarViewModel: ViewModel, ViewModelType {

    struct Input { }

    struct Output {
        let tabBarItems: Driver<[HomeTabBarItem]>
    }

    func transform(input: Input) -> Output {

        let triger = Driver.just(())

        let tabBarItems = triger.map { () -> [HomeTabBarItem] in
            let loggedIn = false
            if loggedIn {
                return [.search, .events, .profile, .notifications, .settings]
            } else {
                return [.search, .login, .settings]
            }
        }

        return Output(tabBarItems: tabBarItems)
    }

    func viewModel(for tabBarItem: HomeTabBarItem) -> ViewModel {
        switch tabBarItem {
        case .search:
            let viewModel = SearchViewModel(provider: provider)
            return viewModel
        case .events:
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
            let viewModel = ViewModel(provider: provider)
            return viewModel
        }
    }
}
