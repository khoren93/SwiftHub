//
//  HomeTabBarController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController

let provider = Api.shared

enum HomeTabBarItem: Int {
    case search, news, profile, notifications, settings, login

    func controller(with viewModel: ViewModel) -> UINavigationController {
        switch self {
        case .search:
            let vc = R.storyboard.main.searchViewController()!
            vc.viewModel = (viewModel as? SearchViewModel)!
            return NavigationController(rootViewController: vc)
        case .news:
            let vc = ViewController()
            return NavigationController(rootViewController: vc)
        case .profile:
            let vc = R.storyboard.main.userViewController()!
            vc.viewModel = (viewModel as? UserViewModel)!
            return NavigationController(rootViewController: vc)
        case .notifications:
            let vc = ViewController()
            return NavigationController(rootViewController: vc)
        case .settings:
            let vc = R.storyboard.main.settingsViewController()!
            vc.viewModel = (viewModel as? SettingsViewModel)!
            return NavigationController(rootViewController: vc)
        case .login:
            let vc = R.storyboard.main.loginViewController()!
            vc.viewModel = (viewModel as? LoginViewModel)!
            return NavigationController(rootViewController: vc)
        }
    }

    var image: UIImage? {
        switch self {
        case .search: return R.image.icon_tabbar_search()
        case .news: return R.image.icon_tabbar_news()
        case .profile: return R.image.icon_tabbar_profile()
        case .notifications: return R.image.icon_tabbar_activity()
        case .settings: return R.image.icon_tabbar_settings()
        case .login: return R.image.icon_tabbar_login()
        }
    }

    var title: String {
        switch self {
        case .search: return "Search"
        case .news: return "News"
        case .profile: return "Profile"
        case .notifications: return "Activities"
        case .settings: return "Settings"
        case .login: return "Login"
        }
    }

    var animation: RAMItemAnimation {
        var animation: RAMItemAnimation
        switch self {
        case .search: animation = RAMFlipLeftTransitionItemAnimations()
        case .news: animation = RAMBounceAnimation()
        case .profile: animation = RAMBounceAnimation()
        case .notifications: animation = RAMBounceAnimation()
        case .settings: animation = RAMRightRotationAnimation()
        case .login: animation = RAMBounceAnimation()
        }
        _ = themeService.bind([
            ({ $0.secondary }, [animation.rx.iconSelectedColor]),
            ({ $0.secondary }, [animation.rx.textSelectedColor])
        ])
        return animation
    }

    func getController(with viewModel: ViewModel) -> UINavigationController {
        let vc = controller(with: viewModel)
        let item = RAMAnimatedTabBarItem(title: nil, image: image, tag: rawValue)
        item.animation = animation
        _ = themeService.bind([
            ({ $0.text }, [item.rx.iconColor]),
            ({ $0.text }, [item.rx.textColor])
        ])
        item.yOffSet = -5
        vc.tabBarItem = item
        return vc
    }
}

class HomeTabBarController: RAMAnimatedTabBarController, Navigatable {

    var viewModel: HomeTabBarViewModel!
    var navigator: Navigator!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        bindViewModel()
        makeUI()
    }

    func makeUI() {
        // Configure tab bar
        hero.isEnabled = true
        tabBar.hero.id = "TabBarID"
        tabBar.isTranslucent = false

        themeService.bind([
            ({ $0.primary }, [tabBar.rx.barTintColor])
        ]).disposed(by: rx.disposeBag)
    }

    func bindViewModel() {
        let input = HomeTabBarViewModel.Input()
        let output = viewModel.transform(input: input)

        output.tabBarItems.drive(onNext: { [weak self] (tabBarItems) in
            if let strongSelf = self {
                let controllers = tabBarItems.map { $0.getController(with: strongSelf.viewModel.viewModel(for: $0)) }
                strongSelf.setViewControllers(controllers, animated: false)
                strongSelf.navigator.injectTabBarControllers(in: strongSelf)
            }
        }).disposed(by: rx.disposeBag)
    }
}
