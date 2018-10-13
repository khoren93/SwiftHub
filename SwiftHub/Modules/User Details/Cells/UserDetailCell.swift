//
//  UserDetailCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 10/13/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class UserDetailCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        themeService.rx
            .bind({ $0.secondary }, to: leftImageView.rx.tintColor)
            .disposed(by: rx.disposeBag)
    }

    func bind(to viewModel: UserDetailCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)

        viewModel.showDisclosure.drive(onNext: { [weak self] (isHidden) in
            self?.rightImageView.isHidden = !isHidden
        }).disposed(by: rx.disposeBag)

        viewModel.image.drive(onNext: { [weak self] (image) in
            self?.leftImageView.image = image?.withRenderingMode(.alwaysTemplate)
        }).disposed(by: rx.disposeBag)
    }
}
