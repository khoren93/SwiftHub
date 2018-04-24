//
//  Navigator.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import UIKit
import SafariServices
import RxCocoa

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {

        // Home Tab Bar
        case tabs

        // Notifications

        // Profile

        // Settings

        // Open URL
        case webPage(URL)
    }

    enum Transition {
        case root(in: UIWindow)
        case navigation, modal
        case maps
    }

    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController {
        switch segue {
        case .tabs:
            let vc = R.storyboard.main.instantiateInitialViewController()!
            return vc

        case .webPage(let url):
            let vc = SFSafariViewController(url: url)
            vc.hidesBottomBarWhenPushed = true
            return vc
        }
    }

    func pop(sender: UIViewController?) {
        sender?.navigationController?.popViewController()
    }

    func dismiss(sender: UIViewController?) {
        sender?.navigationController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation) {
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
        case .maps:
            return
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
        case .navigation:
            if let nav = sender.navigationController {
                //add controller to navigation stack
                nav.pushViewController(target, animated: true)
            }
        case .modal:
            //present modally
            sender.present(NavigationController(rootViewController: target), animated: true, completion: nil)
        default: break
        }
    }

    private func injectNavigator(in target: UIViewController) {
        // view controller
        if var target = target as? Navigatable {
            target.navigator = self
            return
        }

        // tabs
        if let target = target as? UITabBarController {
            if let children = target.viewControllers {
                for vc in children {
                    injectNavigator(in: vc)
                }
            }
        }

        // navigation controller
        if let target = target as? UINavigationController, let root = target.viewControllers.first {
            injectNavigator(in: root)
        }
    }
}
