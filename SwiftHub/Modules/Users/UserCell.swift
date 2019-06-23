//
//  UserCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class UserCell: DefaultTableViewCell {

    lazy var followButton: Button = {
        let view = Button()
        view.borderColor = .white
        view.borderWidth = Configs.BaseDimensions.borderWidth
        view.tintColor = .white
        view.cornerRadius = 17
        view.snp.remakeConstraints({ (make) in
            make.size.equalTo(34)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
        stackView.insertArrangedSubview(followButton, at: 2)
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? UserCellViewModel else { return }

        viewModel.hidesFollowButton.asDriver().drive(followButton.rx.isHidden).disposed(by: rx.disposeBag)
        viewModel.following.asDriver().map { (followed) -> UIImage? in
            let image = followed ? R.image.icon_button_user_x() : R.image.icon_button_user_plus()
            return image?.template
            }.drive(followButton.rx.image()).disposed(by: rx.disposeBag)
        viewModel.following.map { $0 ? 1.0: 0.6 }.asDriver(onErrorJustReturn: 0).drive(followButton.rx.alpha).disposed(by: rx.disposeBag)
    }
}
