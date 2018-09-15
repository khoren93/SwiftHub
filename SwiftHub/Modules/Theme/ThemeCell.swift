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
        leftImageView.cornerRadius = 25
        leftImageView.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }

    func bind(to viewModel: ThemeCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.imageColor.drive(leftImageView.rx.backgroundColor).disposed(by: rx.disposeBag)
    }
}
