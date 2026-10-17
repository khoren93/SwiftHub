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

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
        sectionHeaderHeight = 40
        backgroundColor = .clear
        cellLayoutMarginsFollowReadableWidth = false
        keyboardDismissMode = .onDrag
        separatorColor = .clear
        separatorInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
        tableHeaderView = View(height: 1)
        tableFooterView = UIView()
    }

    /// Called after the rows change, with whether the table is now empty
    var rowsChanged: ((_ isEmpty: Bool) -> Void)?

    var isEmpty: Bool {
        guard let dataSource = dataSource else { return true }
        let sections = dataSource.numberOfSections?(in: self) ?? 1
        return (0..<sections).allSatisfy { dataSource.tableView(self, numberOfRowsInSection: $0) == 0 }
    }

    override func reloadData() {
        super.reloadData()
        rowsChanged?(isEmpty)
    }

    override func endUpdates() {
        super.endUpdates()
        rowsChanged?(isEmpty)
    }

    override func performBatchUpdates(_ updates: (() -> Void)?, completion: ((Bool) -> Void)? = nil) {
        super.performBatchUpdates(updates) { [weak self] finished in
            completion?(finished)
            if let self = self {
                self.rowsChanged?(self.isEmpty)
            }
        }
    }
}

extension UITableView {

    /// Registers a cell from its nib; the nib, the cell class and its reuse identifier share one name
    func registerNib<Cell: UITableViewCell>(_ cellType: Cell.Type) {
        register(UINib(nibName: cellType.reuseID, bundle: nil), forCellReuseIdentifier: cellType.reuseID)
    }
}

extension UITableViewCell {

    static var reuseID: String {
        return String(describing: self)
    }
}
