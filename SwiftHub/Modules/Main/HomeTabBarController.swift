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
    case search, events, profile, notifications, settings

    var controller: UINavigationController {
        switch self {
        case .search:
            let vc = R.storyboard.main.searchViewController()!
            vc.viewModel = SearchViewModel(provider: provider)
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
            vc.viewModel = SettingsViewModel(provider: provider)
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
        }
    }

    var title: String {
        switch self {
        case .search: return "Search"
        case .events: return "News"
        case .profile: return "Profile"
        case .notifications: return "Activities"
        case .settings: return "Settings"
        }
    }

    var animation: RAMItemAnimation {
        let animation = RAMBounceAnimation()
        animation.iconSelectedColor = .secondary()
        return animation
    }

    func getController() -> UINavigationController {
        let vc = self.controller
        let item = RAMAnimatedTabBarItem(title: nil, image: image, tag: rawValue)
        item.animation = animation
        item.iconColor = .white
        item.textColor = .white
        item.yOffSet = -5
        vc.tabBarItem = item
        return vc
    }
}

class HomeTabBarController: RAMAnimatedTabBarController {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Set tab bar controllers
        let viewControllers: [UIViewController] = [HomeTabBarItem.search.getController(),
                                                   HomeTabBarItem.events.getController(),
                                                   HomeTabBarItem.profile.getController(),
                                                   HomeTabBarItem.notifications.getController(),
                                                   HomeTabBarItem.settings.getController()]
        setViewControllers(viewControllers, animated: true)
        makeUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func makeUI() {
        // Configure tab bar
        hero.isEnabled = true
        tabBar.hero.id = "TabBarID"
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.primary()
    }
}
