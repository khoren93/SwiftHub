//
//  PullRequestCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class PullRequestCell: DefaultTableViewCell {

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? PullRequestCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        leftImageView.rx.tap().map { _ in viewModel.pullRequest.user }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
