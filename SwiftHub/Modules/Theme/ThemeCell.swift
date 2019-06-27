//
//  ThemeCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/15/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class ThemeCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        rightImageView.isHidden = true
        leftImageView.cornerRadius = 20
        leftImageView.snp.remakeConstraints { (make) in
            make.size.equalTo(40)
        }
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? ThemeCellViewModel else { return }

        viewModel.imageColor.asDriver().drive(leftImageView.rx.backgroundColor).disposed(by: rx.disposeBag)
    }
}
