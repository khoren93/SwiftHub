//
//  RepositoryDetailCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class RepositoryDetailCell: DetailedTableViewCell {

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

    func bind(to viewModel: RepositoryDetailCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(secondDetailLabel.rx.text).disposed(by: rx.disposeBag)

        viewModel.hidesDisclosure.drive(rightImageView.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.image.drive(onNext: { [weak self] (image) in
            self?.leftImageView.image = image?.template
        }).disposed(by: rx.disposeBag)
    }
}
