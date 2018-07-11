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

    let provider: SwiftHubAPI
    let navigator: Navigator

    private override init() {
        self.provider = Api.shared
        self.navigator = Navigator.default
    }

    func presentInitialScreen(in window: UIWindow) {
        presentHome(in: window)
    }

    func presentHome(in window: UIWindow) {
        let viewModel = HomeTabBarViewModel(provider: provider)
        navigator.show(segue: .tabs(viewModel: viewModel), sender: nil, transition: .root(in: window))
    }
}
