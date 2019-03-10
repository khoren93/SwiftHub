//
//  DetailedTableViewCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class DetailedTableViewCell: DefaultTableViewCell {

    lazy var detailLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(12)
        view.setPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        return view
    }()

    lazy var secondDetailLabel: Label = {
        let view = Label()
        view.font = view.font.bold.withSize(11)
        return view
    }()

    lazy var textsStackView: StackView = {
        let views: [UIView] = [self.titleLabel, self.detailLabel, self.secondDetailLabel]
        let view = StackView(arrangedSubviews: views)
        view.spacing = 2
        return view
    }()

    override func makeUI() {
        super.makeUI()

        themeService.rx
            .bind({ $0.textGray }, to: detailLabel.rx.textColor)
            .bind({ $0.text }, to: secondDetailLabel.rx.textColor)
            .disposed(by: rx.disposeBag)

        titleLabel.removeFromSuperview()
        stackView.removeArrangedSubview(titleLabel)
        stackView.insertArrangedSubview(textsStackView, at: 1)
        stackView.snp.remakeConstraints({ (make) in
            let inset = self.inset
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: inset/2, left: inset, bottom: inset/2, right: inset))
            make.height.greaterThanOrEqualTo(Configs.BaseDimensions.tableRowHeight)
        })
    }
}
