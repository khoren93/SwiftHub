//
//  TableView.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class TableView: UITableView {

    init () {
        super.init(frame: CGRect(), style: .grouped)
    }

    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 50
        backgroundColor = .white
        separatorColor = .separator()
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
