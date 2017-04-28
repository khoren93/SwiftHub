//
//  NavigationController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import AMScrollingNavbar

class NavigationController: ScrollingNavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBar.isTranslucent = false
        navigationBar.barStyle = .blackTranslucent
        let titleTextAttributes = [NSFontAttributeName: Configs.App.NavigationTitleFont,
                                   NSForegroundColorAttributeName: UIColor.white]
        navigationBar.titleTextAttributes = titleTextAttributes

        navigationBar.backIndicatorImage = R.image.icon_navigation_back()?.withRenderingMode(.alwaysOriginal)
        navigationBar.backIndicatorTransitionMaskImage = R.image.icon_navigation_back()?.withRenderingMode(.alwaysOriginal)
    }
}
