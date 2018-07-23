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

        if #available(iOS 11.0, *) {
            navigationBar.prefersLargeTitles = true
            themeService.bind([({
                let color = $0
                return Attributes {
                    return $0.foreground(color: color.text)
                        .font(.boldSystemFont(ofSize: 28))
                    }.dictionary
                }, [navigationBar.rx.largeTitleTextAttributes])
            ]).disposed(by: rx.disposeBag)
        }

        themeService.bind([
            ({ $0.secondary }, [navigationBar.rx.tintColor]),
            ({ $0.primary }, [navigationBar.rx.barTintColor])
        ]).disposed(by: rx.disposeBag)

        themeService.bind([
            ({ [NSAttributedStringKey.foregroundColor: $0.text] }, [navigationBar.rx.titleTextAttributes])
        ]).disposed(by: rx.disposeBag)
    }
}
