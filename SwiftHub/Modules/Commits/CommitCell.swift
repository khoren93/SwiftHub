//
//  CommitCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class CommitCell: DetailedTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
    }

    func bind(to viewModel: CommitCellViewModel) {
        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.secondDetail.drive(secondDetailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.leftImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)
        viewModel.badge.drive(badgeImageView.rx.image).disposed(by: rx.disposeBag)
        viewModel.badgeColor.drive(badgeImageView.rx.tintColor).disposed(by: rx.disposeBag)

        leftImageView.rx.tap().map { _ in viewModel.commit.committer }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
