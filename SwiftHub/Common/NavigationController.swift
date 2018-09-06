//
//  NavigationController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import AttributedLib

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        hero.isEnabled = true
        hero.modalAnimationType = .autoReverse(presenting: .fade)
        hero.navigationAnimationType = .autoReverse(presenting: .slide(direction: .left))

        navigationBar.isTranslucent = false
        navigationBar.backIndicatorImage = R.image.icon_navigation_back()
        navigationBar.backIndicatorTransitionMaskImage = R.image.icon_navigation_back()
/*
        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            themeService.rx
                .bind({ color in
                    Attributes {
                        $0.foreground(color: color.text)
                            .font(.boldSystemFont(ofSize: 28))
                        }.dictionary
                }, to: navigationBar.rx.largeTitleTextAttributes)
                .bind({ $0.primary }, to: navigationBar.rx.backgroundColor)
                .disposed(by: rx.disposeBag)
        }
*/
        themeService.rx
            .bind({ $0.secondary }, to: navigationBar.rx.tintColor)
            .bind({ $0.primaryDark }, to: navigationBar.rx.barTintColor)
            .bind({ [NSAttributedStringKey.foregroundColor: $0.text] }, to: navigationBar.rx.titleTextAttributes)
            .disposed(by: rx.disposeBag)
    }
}
