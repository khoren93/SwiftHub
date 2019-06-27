//
//  NotificationCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 9/19/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class NotificationCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        leftImageView.cornerRadius = 25
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? NotificationCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        leftImageView.rx.tap().map { _ in viewModel.notification.repository?.owner }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
