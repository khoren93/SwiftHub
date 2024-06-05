//
//  IssueCommentsViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/7/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MessageKit

class IssueCommentsViewController: ChatViewController {

    var viewModel: IssueCommentsViewModel!

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(Observable.just(()), themeService.typeStream.mapToVoid()).merge()
        let input = IssueCommentsViewModel.Input(headerRefresh: refresh,
                                                 sendSelected: sendPressed)
        let output = viewModel.transform(input: input)

        output.items.subscribe(onNext: { [weak self] (comments) in
            self?.messages = comments
        }).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
