//
//  EventCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class EventCell: DetailedTableViewCell {

    var cellDisposeBag = DisposeBag()

    override func makeUI() {
        super.makeUI()
        titleLabel.numberOfLines = 2
        leftImageView.cornerRadius = 25
    }

    func bind(to viewModel: EventCellViewModel) {
        cellDisposeBag = DisposeBag()

        viewModel.title.drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)
        viewModel.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.leftImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        leftImageView.rx.tapGesture().when(.recognized).map { _ in viewModel.event.actor }.filterNil()
            .bind(to: viewModel.userSelected).disposed(by: cellDisposeBag)
    }
}
