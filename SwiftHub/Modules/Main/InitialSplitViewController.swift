//
//  InitialSplitViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class InitialSplitViewController: TableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }

        emptyDataSetTitle = R.string.localizable.initialNoResults.key.localized()
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }
}
