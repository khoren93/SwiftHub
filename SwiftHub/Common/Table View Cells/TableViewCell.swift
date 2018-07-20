//
//  TableViewCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var isSelection = false

    lazy var containerView: View = {
        let view = View()
        view.backgroundColor = .clear
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()

    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .center
        self.containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(inset)
        })
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func makeUI() {
        self.layer.masksToBounds = true
        self.selectionStyle = .none
        backgroundColor = .clear
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
