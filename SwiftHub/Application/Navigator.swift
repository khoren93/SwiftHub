//
//  Navigator.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SafariServices
import Hero
import AcknowList

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {
        case tabs(viewModel: HomeTabBarViewModel)
        case search(viewModel: SearchViewModel)
        case userDetails(viewModel: UserViewModel)
        case repositoryDetails(viewModel: RepositoryViewModel)
        case acknowledgements
        case webPage(URL)
        case alert(title: String, description: String, image: UIImage?, imageID: String?, actions: [AlertAction])
    }

    enum Transition {
        case root(in: UIWindow)
        case navigation(type: HeroDefaultAnimationType)
        case customModal(type: HeroDefaultAnimationType)
        case modal
        case alert
        case custom
    }

    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController {
        switch segue {
        case .tabs(let viewModel):
            let vc = R.storyboard.main.homeTabBarController()!
            vc.viewModel = viewModel
            return vc

        case .search(let viewModel):
            let vc = R.storyboard.main.searchViewController()!
            vc.viewModel = viewModel
            return vc

        case .userDetails(let viewModel):
            let vc = R.storyboard.main.userViewController()!
            vc.viewModel = viewModel
            return vc

        case .repositoryDetails(let viewModel):
            let vc = R.storyboard.main.repositoryViewController()!
            vc.viewModel = viewModel
            return vc

        case .acknowledgements:
            let vc = AcknowListViewController()
            return vc

        case .webPage(let url):
            let vc = SFSafariViewController(url: url)
//            vc.hidesBottomBarWhenPushed = true
            return vc

        case .alert(let title, let description, let image, let imageID, let actions):
            let alert = AlertController(title: title, description: description, image: image, style: AlertControllerStyle.alert)
            alert.hero.isEnabled = true
            alert.alertImage.hero.id = imageID
            alert.alertImage.hero.modifiers = [.arc]
            alert.alertImage.contentMode = .scaleAspectFill
            actions.forEach { (action) in
                alert.addAction(action)
            }
            return alert
        }
    }

    func pop(sender: UIViewController?, toRoot: Bool = false) {
        if toRoot {
            sender?.navigationController?.popToRootViewController(animated: true)
        } else {
            sender?.navigationController?.popViewController()
        }
    }

    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }

    func injectTabBarControllers(in target: UITabBarController) {
        if let children = target.viewControllers {
            for vc in children {
                injectNavigator(in: vc)
            }
        }
    }

    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation(type: .cover(direction: .left))) {
        let target = get(segue: segue)

        show(target: target, sender: sender, transition: transition)
    }

    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
        injectNavigator(in: target)

        switch transition {
        case .root(in: let window):
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                window.rootViewController = target
            }, completion: nil)
            return
        case .custom: return
        default: break
        }

        guard let sender = sender else {
            fatalError("You need to pass in a sender for .navigation or .modal transitions")
        }

        if let nav = sender as? UINavigationController {
            //push root controller on navigation stack
            nav.pushViewController(target, animated: false)
            return
        }

        switch transition {
        case .navigation(let type):
            if let nav = sender.navigationController {
                //add controller to navigation stack
                nav.hero.navigationAnimationType = .autoReverse(presenting: type)
                nav.pushViewController(target, animated: true)
            }
        case .customModal(let type):
            //present modally with custom animation
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                nav.hero.modalAnimationType = .autoReverse(presenting: type)
                sender.present(nav, animated: true, completion: nil)
            }
        case .modal:
            //present modally
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: nil)
            }
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
        default: break
        }
    }

    private func injectNavigator(in target: UIViewController) {
        // view controller
        if var target = target as? Navigatable {
            target.navigator = self
            return
        }

        // navigation controller
        if let target = target as? UINavigationController, let root = target.viewControllers.first {
            injectNavigator(in: root)
        }
    }
}
