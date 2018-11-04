//
//  Application.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

final class Application: NSObject {
    static let shared = Application()

    var window: UIWindow?

    let provider: SwiftHubAPI
    let authManager: AuthManager
    let navigator: Navigator

    private override init() {
        provider = Api.shared
        authManager = AuthManager.shared
        navigator = Navigator.default
        super.init()

        authManager.tokenChanged.subscribe(onNext: { [weak self] (token) in
            if let window = self?.window, token == nil || token?.isValid == true {
                self?.presentInitialScreen(in: window)
            }
        }).disposed(by: rx.disposeBag)
    }

    func presentInitialScreen(in window: UIWindow) {
        self.window = window

        if let user = User.currentUser(), let userId = user.id?.string {
            analytics.identify(userId: userId)
            analytics.updateUser(name: user.name ?? "", email: user.email ?? "")
        }

        let loggedIn = authManager.hasToken
        let viewModel = HomeTabBarViewModel(loggedIn: loggedIn, provider: provider)
        navigator.show(segue: .tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
}
