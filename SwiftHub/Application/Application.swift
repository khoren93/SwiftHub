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
    }

    func presentInitialScreen(in window: UIWindow?) {
        guard let window = window else { return }
        self.window = window

//        presentTestScreen(in: window)
//        return

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let user = User.currentUser(), let userId = user.id?.string {
                analytics.identify(userId: userId)
                analytics.updateUser(name: user.name ?? "", email: user.email ?? "")
            }

            let loggedIn = self.authManager.hasValidToken
            let viewModel = HomeTabBarViewModel(loggedIn: loggedIn, provider: self.provider)
            self.navigator.show(segue: .tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
        }
    }

    func presentTestScreen(in window: UIWindow?) {
        guard let window = window else { return }
        let viewModel = UserViewModel(user: nil, provider: provider)
        navigator.show(segue: .userDetails(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
}
