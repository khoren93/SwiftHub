//
//  ReleaseCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/12/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit

class ReleaseCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
        secondDetailLabel.numberOfLines = 0
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? ReleaseCellViewModel else { return }

        leftImageView.rx.tap().map { _ in viewModel.release.author }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
