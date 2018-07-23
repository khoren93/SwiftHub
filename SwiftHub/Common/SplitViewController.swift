//
//  SplitViewController.swift
//  CakeBuilderBakery
//
//  Created by Khoren Markosyan on 3/13/17.
//  Copyright © 2017 GAVR. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        delegate = self
        preferredDisplayMode = .allVisible
    }
}

extension SplitViewController: UISplitViewControllerDelegate {

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
