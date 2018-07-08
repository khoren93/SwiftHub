//
//  SettingCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class SettingCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.isHidden = true
    }

    func bind(to viewModel: SettingCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)

        viewModel.showDisclosure.drive(onNext: { (isHidden) in
            self.rightImageView.isHidden = !isHidden
        }).disposed(by: rx.disposeBag)

        viewModel.imageName.drive(onNext: { (imageName) in
            self.leftImageView.image = UIImage(named: imageName)
        }).disposed(by: rx.disposeBag)
    }
}
