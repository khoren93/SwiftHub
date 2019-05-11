//
//  IssueCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class IssueCell: DetailedTableViewCell {

    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        leftImageView.cornerRadius = 25
    }

    func bind(to viewModel: IssueCellViewModel) {
        cellDisposeBag = DisposeBag()

        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)
        viewModel.badge.drive(badgeImageView.rx.image).disposed(by: rx.disposeBag)
        viewModel.badgeColor.drive(badgeImageView.rx.tintColor).disposed(by: rx.disposeBag)
        viewModel.imageUrl.filterNil().drive(onNext: { [weak self] (url) in
            self?.leftImageView.hero.id = url.absoluteString
        }).disposed(by: rx.disposeBag)

        leftImageView.rx.tap().map { _ in viewModel.issue.user }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
