//
//  BranchCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/6/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit

class BranchCell: DetailedTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
    }

    func bind(to viewModel: BranchCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.secondDetail.drive(secondDetailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.image.drive(leftImageView.rx.image).disposed(by: rx.disposeBag)
    }
}
