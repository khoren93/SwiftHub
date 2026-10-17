//
//  HomeTabBarController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

enum HomeTabBarItem: Int {
    case search, news, notifications, settings, login

    private func controller(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        switch self {
        case .search:
            let vc = SearchViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
        case .news:
            let vc = EventsViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
        case .notifications:
            let vc = NotificationsViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
        case .settings:
            let vc = SettingsViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
        case .login:
            let vc = LoginViewController(viewModel: viewModel, navigator: navigator)
            return NavigationController(rootViewController: vc)
        }
    }

    var image: UIImage? {
        switch self {
        case .search: return UIImage(resource: .iconTabbarSearch)
        case .news: return UIImage(resource: .iconTabbarNews)
        case .notifications: return UIImage(resource: .iconTabbarActivity)
        case .settings: return UIImage(resource: .iconTabbarSettings)
        case .login: return UIImage(resource: .iconTabbarLogin)
        }
    }

    var title: String {
        switch self {
        case .search: return String(localized: .homeTabBarSearchTitle)
        case .news: return String(localized: .homeTabBarEventsTitle)
        case .notifications: return String(localized: .homeTabBarNotificationsTitle)
        case .settings: return String(localized: .homeTabBarSettingsTitle)
        case .login: return String(localized: .homeTabBarLoginTitle)
        }
    }

    func getController(with viewModel: ViewModel, navigator: Navigator) -> UIViewController {
        let vc = controller(with: viewModel, navigator: navigator)
        let item = UITabBarItem(title: title, image: image, tag: rawValue)
        vc.tabBarItem = item
        return vc
    }
}

class HomeTabBarController: UITabBarController, Navigatable {

    var viewModel: HomeTabBarViewModel?
    var navigator: Navigator!

    init(viewModel: ViewModel?, navigator: Navigator) {
        self.viewModel = viewModel as? HomeTabBarViewModel
        self.navigator = navigator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        themeService.typeStream.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (theme) in
                self?.updateTabBarAppearance(with: theme.associatedObject)
            }).disposed(by: rx.disposeBag)
    }

    private func updateTabBarAppearance(with theme: Theme) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        appearance.backgroundColor = theme.primaryDark

        let itemAppearance = UITabBarItemAppearance()
        itemAppearance.normal.iconColor = theme.text
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: theme.text]
        itemAppearance.selected.iconColor = theme.secondary
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: theme.secondary]

        appearance.stackedLayoutAppearance = itemAppearance
        appearance.inlineLayoutAppearance = itemAppearance
        appearance.compactInlineLayoutAppearance = itemAppearance

        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = theme.secondary
        tabBar.unselectedItemTintColor = theme.text

        // Force immediate update
        tabBar.setNeedsLayout()
        tabBar.layoutIfNeeded()
    }

    func bindViewModel() {
        guard let viewModel = viewModel else { return }

        let input = HomeTabBarViewModel.Input()
        let output = viewModel.transform(input: input)

        output.tabBarItems.delay(.milliseconds(50)).drive(onNext: { [weak self] (tabBarItems) in
            if let strongSelf = self {
                let controllers = tabBarItems.map { $0.getController(with: viewModel.viewModel(for: $0), navigator: strongSelf.navigator) }
                strongSelf.setViewControllers(controllers, animated: false)
            }
        }).disposed(by: rx.disposeBag)
    }
}
