//
//  HomeTabBarController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RAMAnimatedTabBarController
import Localize_Swift

enum HomeTabBarItem: Int {
    case search, news, profile, notifications, settings, login

    func controller(with viewModel: ViewModel) -> UIViewController {
        switch self {
        case .search:
            let vc = R.storyboard.main.searchViewController()!
            vc.viewModel = (viewModel as? SearchViewModel)!
            return NavigationController(rootViewController: vc)
        case .news:
            let vc = R.storyboard.main.eventsViewController()!
            vc.viewModel = (viewModel as? EventsViewModel)!
            return NavigationController(rootViewController: vc)
        case .profile:
            let vc = R.storyboard.main.userViewController()!
            vc.viewModel = (viewModel as? UserViewModel)!
            return NavigationController(rootViewController: vc)
        case .notifications:
            let vc = R.storyboard.main.notificationsViewController()!
            vc.viewModel = (viewModel as? NotificationsViewModel)!
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
        case .search: return R.string.localizable.homeTabBarSearchTitle.key.localized()
        case .news: return R.string.localizable.homeTabBarEventsTitle.key.localized()
        case .profile: return R.string.localizable.homeTabBarProfileTitle.key.localized()
        case .notifications: return R.string.localizable.homeTabBarNotificationsTitle.key.localized()
        case .settings: return R.string.localizable.homeTabBarSettingsTitle.key.localized()
        case .login: return R.string.localizable.homeTabBarLoginTitle.key.localized()
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
        _ = themeService.rx
            .bind({ $0.secondary }, to: animation.rx.iconSelectedColor)
            .bind({ $0.secondary }, to: animation.rx.textSelectedColor)
        return animation
    }

    func getController(with viewModel: ViewModel) -> UIViewController {
        let vc = controller(with: viewModel)
        let item = RAMAnimatedTabBarItem(title: title, image: image, tag: rawValue)
        item.animation = animation
        _ = themeService.rx
            .bind({ $0.text }, to: item.rx.iconColor)
            .bind({ $0.text }, to: item.rx.textColor)

        item.yOffSet = -1
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
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        // Configure tab bar
        hero.isEnabled = true
        tabBar.hero.id = "TabBarID"
        tabBar.isTranslucent = false

        NotificationCenter.default
            .rx.notification(NSNotification.Name(LCLLanguageChangeNotification))
            .subscribe { [weak self] (event) in
                self?.animatedItems.forEach({ (item) in
                    item.title = HomeTabBarItem(rawValue: item.tag)?.title
                })
                self?.viewControllers = self?.viewControllers
            }.disposed(by: rx.disposeBag)

        themeService.rx
            .bind({ $0.primaryDark }, to: tabBar.rx.barTintColor)
            .disposed(by: rx.disposeBag)
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
