//
//  RepositoryCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class RepositoryCell: DetailedTableViewCell {

    lazy var starButton: Button = {
        let view = Button()
        view.borderColor = .white
        view.borderWidth = Configs.BaseDimensions.borderWidth
        view.tintColor = .white
        view.cornerRadius = 16
        view.snp.remakeConstraints({ (make) in
            make.size.equalTo(32)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
        stackView.insertArrangedSubview(starButton, at: 2)
    }

    func bind(to viewModel: RepositoryCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.secondDetail.drive(secondDetailLabel.rx.attributedText).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.leftImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)
        viewModel.badge.drive(badgeImageView.rx.image).disposed(by: rx.disposeBag)
        viewModel.badgeColor.drive(badgeImageView.rx.tintColor).disposed(by: rx.disposeBag)
        viewModel.hidesStarButton.drive(starButton.rx.isHidden).disposed(by: rx.disposeBag)
        viewModel.starring.map { (starred) -> UIImage? in
            let image = starred ? R.image.icon_button_unstar() : R.image.icon_button_star()
            return image?.template
        }.drive(starButton.rx.image()).disposed(by: rx.disposeBag)
        viewModel.starring.map { $0 ? 1.0: 0.7 }.drive(starButton.rx.alpha).disposed(by: rx.disposeBag)
    }
}
