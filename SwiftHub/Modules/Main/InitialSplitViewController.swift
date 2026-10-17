//
//  InitialSplitViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class InitialSplitViewController: TableViewController {

    override func makeUI() {
        super.makeUI()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        }

        emptyDataSetTitle = String(localized: .initialNoResults)
        isHeaderRefreshEnabled = false
        isFooterRefreshEnabled = false
    }
}
