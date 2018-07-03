//
//  HomeTabBarController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

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
            let vc = ViewController()
            return NavigationController(rootViewController: vc)
        }
    }

    var image: UIImage? {
        switch self {
        case .search: return R.image.icon_favorite()
        case .events: return R.image.icon_favorite()
        case .profile: return R.image.icon_favorite()
        case .notifications: return R.image.icon_favorite()
        case .settings: return R.image.icon_favorite()
        }
    }

    var imageInsets: UIEdgeInsets {
        let inset: CGFloat = 0
        return UIEdgeInsets(top: inset, left: 0, bottom: -inset, right: 0)
    }

    var title: String {
        switch self {
        case .search: return "Search"
        case .events: return "Events"
        case .profile: return "Profile"
        case .notifications: return "Notifications"
        case .settings: return "Settings"
        }
    }

    func getController() -> UINavigationController {
        let vc = self.controller
        vc.tabBarItem = UITabBarItem(title: self.title,
                                     image: self.image,
                                     tag: self.rawValue)
        vc.tabBarItem.imageInsets = self.imageInsets
        return vc
    }
}

class HomeTabBarController: UITabBarController {

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
        tabBar.tintColor = UIColor.secondary()

        if #available(iOS 10.0, *) {
            tabBar.unselectedItemTintColor = UIColor.flatWhite
        } else {
            // Fallback on earlier versions
        }
    }
}
