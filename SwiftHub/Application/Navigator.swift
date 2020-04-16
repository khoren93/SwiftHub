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
import WhatsNewKit
import MessageUI

protocol Navigatable {
    var navigator: Navigator! { get set }
}

class Navigator {
    static var `default` = Navigator()

    // MARK: - segues list, all app scenes
    enum Scene {
        case tabs(viewModel: HomeTabBarViewModel)
        case search(viewModel: SearchViewModel)
        case languages(viewModel: LanguagesViewModel)
        case users(viewModel: UsersViewModel)
        case userDetails(viewModel: UserViewModel)
        case repositories(viewModel: RepositoriesViewModel)
        case repositoryDetails(viewModel: RepositoryViewModel)
        case contents(viewModel: ContentsViewModel)
        case source(viewModel: SourceViewModel)
        case commits(viewModel: CommitsViewModel)
        case branches(viewModel: BranchesViewModel)
        case releases(viewModel: ReleasesViewModel)
        case pullRequests(viewModel: PullRequestsViewModel)
        case pullRequestDetails(viewModel: PullRequestViewModel)
        case events(viewModel: EventsViewModel)
        case notifications(viewModel: NotificationsViewModel)
        case issues(viewModel: IssuesViewModel)
        case issueDetails(viewModel: IssueViewModel)
        case linesCount(viewModel: LinesCountViewModel)
        case theme(viewModel: ThemeViewModel)
        case language(viewModel: LanguageViewModel)
        case acknowledgements
        case contacts(viewModel: ContactsViewModel)
        case whatsNew(block: WhatsNewBlock)
        case safari(URL)
        case safariController(URL)
        case webController(URL)
    }

    enum Transition {
        case root(in: UIWindow)
        case navigation(type: HeroDefaultAnimationType)
        case customModal(type: HeroDefaultAnimationType)
        case modal
        case detail
        case alert
        case custom
    }

    // MARK: - get a single VC
    func get(segue: Scene) -> UIViewController? {
        switch segue {
        case .tabs(let viewModel):
            let rootVC = HomeTabBarController(viewModel: viewModel, navigator: self)
            let detailVC = InitialSplitViewController(viewModel: nil, navigator: self)
            let detailNavVC = NavigationController(rootViewController: detailVC)
            let splitVC = SplitViewController()
            splitVC.viewControllers = [rootVC, detailNavVC]
            return splitVC

        case .search(let viewModel): return SearchViewController(viewModel: viewModel, navigator: self)
        case .languages(let viewModel): return LanguagesViewController(viewModel: viewModel, navigator: self)
        case .users(let viewModel): return UsersViewController(viewModel: viewModel, navigator: self)
        case .userDetails(let viewModel): return UserViewController(viewModel: viewModel, navigator: self)
        case .repositories(let viewModel): return RepositoriesViewController(viewModel: viewModel, navigator: self)
        case .repositoryDetails(let viewModel): return RepositoryViewController(viewModel: viewModel, navigator: self)
        case .contents(let viewModel): return ContentsViewController(viewModel: viewModel, navigator: self)
        case .source(let viewModel): return SourceViewController(viewModel: viewModel, navigator: self)
        case .commits(let viewModel): return CommitsViewController(viewModel: viewModel, navigator: self)
        case .branches(let viewModel): return BranchesViewController(viewModel: viewModel, navigator: self)
        case .releases(let viewModel): return ReleasesViewController(viewModel: viewModel, navigator: self)
        case .pullRequests(let viewModel): return PullRequestsViewController(viewModel: viewModel, navigator: self)
        case .pullRequestDetails(let viewModel): return PullRequestViewController(viewModel: viewModel, navigator: self)
        case .events(let viewModel): return EventsViewController(viewModel: viewModel, navigator: self)
        case .notifications(let viewModel): return NotificationsViewController(viewModel: viewModel, navigator: self)
        case .issues(let viewModel): return IssuesViewController(viewModel: viewModel, navigator: self)
        case .issueDetails(let viewModel): return IssueViewController(viewModel: viewModel, navigator: self)
        case .linesCount(let viewModel): return LinesCountViewController(viewModel: viewModel, navigator: self)
        case .theme(let viewModel): return ThemeViewController(viewModel: viewModel, navigator: self)
        case .language(let viewModel): return LanguageViewController(viewModel: viewModel, navigator: self)
        case .acknowledgements: return AcknowListViewController()
        case .contacts(let viewModel): return ContactsViewController(viewModel: viewModel, navigator: self)

        case .whatsNew(let block):
            if let versionStore = block.2 {
                return WhatsNewViewController(whatsNew: block.0, configuration: block.1, versionStore: versionStore)
            } else {
                return WhatsNewViewController(whatsNew: block.0, configuration: block.1)
            }

        case .safari(let url):
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return nil

        case .safariController(let url):
            let vc = SFSafariViewController(url: url)
            return vc

        case .webController(let url):
            let vc = WebViewController(viewModel: nil, navigator: self)
            vc.load(url: url)
            return vc
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

    // MARK: - invoke a single segue
    func show(segue: Scene, sender: UIViewController?, transition: Transition = .navigation(type: .cover(direction: .left))) {
        if let target = get(segue: segue) {
            show(target: target, sender: sender, transition: transition)
        }
    }

    private func show(target: UIViewController, sender: UIViewController?, transition: Transition) {
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
                // push controller to navigation stack
                nav.hero.navigationAnimationType = .autoReverse(presenting: type)
                nav.pushViewController(target, animated: true)
            }
        case .customModal(let type):
            // present modally with custom animation
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                nav.hero.modalAnimationType = .autoReverse(presenting: type)
                sender.present(nav, animated: true, completion: nil)
            }
        case .modal:
            // present modally
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.present(nav, animated: true, completion: nil)
            }
        case .detail:
            DispatchQueue.main.async {
                let nav = NavigationController(rootViewController: target)
                sender.showDetailViewController(nav, sender: nil)
            }
        case .alert:
            DispatchQueue.main.async {
                sender.present(target, animated: true, completion: nil)
            }
        default: break
        }
    }

    func toInviteContact(withPhone phone: String) -> MFMessageComposeViewController {
        let vc = MFMessageComposeViewController()
        vc.body = "Hey! Come join SwiftHub at \(Configs.App.githubUrl)"
        vc.recipients = [phone]
        return vc
    }
}
