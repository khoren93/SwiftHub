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
    case search, events, profile, notifications, settings, login

    func controller(with viewModel: ViewModel) -> UINavigationController {
        switch self {
        case .search:
            let vc = R.storyboard.main.searchViewController()!
            vc.viewModel = (viewModel as? SearchViewModel)!
            return NavigationController(rootViewController: vc)
        case .events:
            let vc = ViewController()
            return NavigationController(rootViewController: vc)
        case .profile:
            let vc = ViewController()
            return NavigationController(rootViewController: vc)
        case .notifications:
            let vc = ViewController()
            return NavigationController(rootViewController: vc)
        case .settings:
            let vc = R.storyboard.main.settingsViewController()!
            vc.viewModel = (viewModel as? SettingsViewModel)!
            return NavigationController(rootViewController: vc)
        case .login:
            let vc = ViewController()
            return NavigationController(rootViewController: vc)
        }
    }

    var image: UIImage? {
        switch self {
        case .search: return R.image.icon_tabbar_search()
        case .events: return R.image.icon_tabbar_news()
        case .profile: return R.image.icon_tabbar_profile()
        case .notifications: return R.image.icon_tabbar_activity()
        case .settings: return R.image.icon_tabbar_settings()
        case .login: return R.image.icon_tabbar_login()
        }
    }

    var title: String {
        switch self {
        case .search: return "Search"
        case .events: return "News"
        case .profile: return "Profile"
        case .notifications: return "Activities"
        case .settings: return "Settings"
        case .login: return "Login"
        }
    }

    var animation: RAMItemAnimation {
        let animation = RAMBounceAnimation()
        animation.iconSelectedColor = .secondary()
        return animation
    }

    func getController(with viewModel: ViewModel) -> UINavigationController {
        let vc = controller(with: viewModel)
        let item = RAMAnimatedTabBarItem(title: nil, image: image, tag: rawValue)
        item.animation = animation
        item.iconColor = .white
        item.textColor = .white
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
        tabBar.barTintColor = UIColor.primary()
    }

    func bindViewModel() {
        let input = HomeTabBarViewModel.Input()
        let output = viewModel.transform(input: input)

        output.tabBarItems.drive(onNext: { [weak self] (tabBarItems) in
            if let strongSelf = self {
                let controllers = tabBarItems.map { $0.getController(with: strongSelf.viewModel.viewModel(for: $0)) }
                strongSelf.setViewControllers(controllers, animated: true)
                strongSelf.navigator.injectTabBarControllers(in: strongSelf)
            }
        }).disposed(by: rx.disposeBag)
    }
}
