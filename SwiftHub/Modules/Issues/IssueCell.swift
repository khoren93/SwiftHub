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

    lazy var iconImageView: ImageView = {
        let view = ImageView(frame: CGRect())
        view.backgroundColor = .white
        view.cornerRadius = 10
        containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.bottom.right.equalTo(self.leftImageView)
            make.size.equalTo(20)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        leftImageView.cornerRadius = 25
        themeService.rx
            .bind({ $0.secondary }, to: leftImageView.rx.tintColor)
            .disposed(by: rx.disposeBag)
    }

    func bind(to viewModel: IssueCellViewModel) {
        cellDisposeBag = DisposeBag()

        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)
        viewModel.icon.drive(iconImageView.rx.image).disposed(by: rx.disposeBag)
        viewModel.iconColor.drive(iconImageView.rx.tintColor).disposed(by: rx.disposeBag)

        leftImageView.rx.tapGesture().when(.recognized).map { _ in viewModel.issue.user }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
