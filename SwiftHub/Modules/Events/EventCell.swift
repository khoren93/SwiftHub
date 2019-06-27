//
//  EventCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class EventCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        secondDetailLabel.numberOfLines = 0
        leftImageView.cornerRadius = 25
    }

    override func bind(to viewModel: DefaultTableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? EventCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        leftImageView.rx.tap().map { _ in viewModel.event.actor }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
