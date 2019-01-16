//
//  ContactCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/15/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit

class ContactCell: DetailedTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
    }

    func bind(to viewModel: ContactCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.image.drive(leftImageView.rx.image).disposed(by: rx.disposeBag)
    }
}
