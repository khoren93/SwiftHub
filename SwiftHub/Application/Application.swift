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

    var provider: SwiftHubAPI?
    let authManager: AuthManager
    let navigator: Navigator

    private override init() {
        authManager = AuthManager.shared
        navigator = Navigator.default
        super.init()
        updateProvider()
    }

    private func updateProvider() {
        let staging = Configs.Network.useStaging
        let githubProvider = staging ? GithubNetworking.stubbingNetworking(): GithubNetworking.defaultNetworking()
        let trendingGithubProvider = staging ? TrendingGithubNetworking.stubbingNetworking(): TrendingGithubNetworking.defaultNetworking()
        let codetabsProvider = staging ? CodetabsNetworking.stubbingNetworking(): CodetabsNetworking.defaultNetworking()
        let restApi = RestApi(githubProvider: githubProvider, trendingGithubProvider: trendingGithubProvider, codetabsProvider: codetabsProvider)
        provider = restApi

        if let token = authManager.token, Configs.Network.useStaging == false {
            switch token.type() {
            case .oAuth(let token):
                provider = GraphApi(restApi: restApi, token: token)
            default: break
            }
        }
    }

    func presentInitialScreen(in window: UIWindow?) {
        updateProvider()
        guard let window = window, let provider = provider else { return }
        self.window = window

//        presentTestScreen(in: window)
//        return

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let user = User.currentUser(), let login = user.login {
                analytics.identify(userId: login)
                analytics.updateUser(name: user.name ?? "", email: user.email ?? "")
            }

            let viewModel = HomeTabBarViewModel(provider: provider)
            self.navigator.show(segue: .tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
        }
    }

    func presentTestScreen(in window: UIWindow?) {
        guard let window = window, let provider = provider else { return }
        let viewModel = UserViewModel(user: User(), provider: provider)
        navigator.show(segue: .userDetails(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
}
