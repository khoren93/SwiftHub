//
//  NavigationController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hero.isEnabled = true
        hero.modalAnimationType = .autoReverse(presenting: .fade)
        hero.navigationAnimationType = .autoReverse(presenting: .slide(direction: .left))

        navigationBar.tintColor = .secondary()
        navigationBar.barTintColor = .primary()
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .black

        let titleTextAttributes = [NSAttributedStringKey.font: Configs.App.NavigationTitleFont,
                                   NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationBar.titleTextAttributes = titleTextAttributes

        navigationBar.backIndicatorImage = R.image.icon_navigation_back()//?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorTransitionMaskImage = R.image.icon_navigation_back()//?.withRenderingMode(.alwaysOriginal)
    }
}
