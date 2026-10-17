//
//  NavigationController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return globalStatusBarStyle.value
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        interactivePopGestureRecognizer?.delegate = nil // Enable default iOS back swipe gesture

//        navigationBar.isTranslucent = false
        navigationBar.backIndicatorImage = UIImage(resource: .iconNavigationBack)
        navigationBar.backIndicatorTransitionMaskImage = UIImage(resource: .iconNavigationBack)

        navigationBar.theme.tintColor = themeService.attribute { $0.secondary }
//        navigationBar.theme.barTintColor = themeService.attribute { $0.primaryDark }
        navigationBar.theme.titleTextAttributes = themeService.attribute { [NSAttributedString.Key.foregroundColor: $0.text] }
    }
}
