//
//  CommitCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class CommitCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? CommitCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        leftImageView.rx.tap().map { _ in viewModel.commit.committer }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
