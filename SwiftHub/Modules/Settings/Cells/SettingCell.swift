//
//  SettingCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class SettingCell: DetailedTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.snp.remakeConstraints { (make) in
            make.size.equalTo(40)
        }
        detailLabel.isHidden = true
        secondDetailLabel.textAlignment = .right
        textsStackView.axis = .horizontal
        textsStackView.distribution = .fillEqually
    }

    func bind(to viewModel: SettingCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(secondDetailLabel.rx.text).disposed(by: rx.disposeBag)

        viewModel.showDisclosure.drive(onNext: { [weak self] (isHidden) in
            self?.rightImageView.isHidden = !isHidden
        }).disposed(by: rx.disposeBag)

        viewModel.imageName.drive(onNext: { [weak self] (imageName) in
            self?.leftImageView.image = UIImage(named: imageName)?.template
        }).disposed(by: rx.disposeBag)
    }
}
