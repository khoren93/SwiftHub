//
//  IssueCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class IssueCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        leftImageView.cornerRadius = 25
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? IssueCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        leftImageView.rx.tap().map { _ in viewModel.issue.user }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
