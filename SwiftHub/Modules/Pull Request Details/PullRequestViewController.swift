//
//  PullRequestViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/12/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MessageKit

class PullRequestViewController: ViewController {

    let conversationVC = PullRequestCommentsViewController()

    /// Required for the `MessageInputBar` to be visible
    override var canBecomeFirstResponder: Bool {
        return conversationVC.canBecomeFirstResponder
    }

    /// Required for the `MessageInputBar` to be visible
    override var inputAccessoryView: UIView? {
        return conversationVC.inputAccessoryView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        bannerView.isHidden = true

        /// Add the `ConversationViewController` as a child view controller
        guard let viewModel = viewModel as? PullRequestViewModel else { return }
        conversationVC.viewModel = viewModel.pullRequestCommentsViewModel()
        conversationVC.willMove(toParent: self)
        addChild(conversationVC)
        stackView.addArrangedSubview(conversationVC.view)
        conversationVC.didMove(toParent: self)
    }

    override func makeUI() {
        super.makeUI()

        navigationController?.hero.isEnabled = false
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? PullRequestViewModel else { return }

        let refresh = Observable.of(Observable.just(())).merge()
        let input = PullRequestViewModel.Input(headerRefresh: refresh,
                                         userSelected: conversationVC.senderSelected.map { $0 as? User}.filterNil(),
                                         mentionSelected: conversationVC.mentionSelected)
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        //        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        //        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)

        output.userSelected.subscribe(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        conversationVC.urlSelected.subscribe(onNext: { [weak self] (url) in
            self?.navigator.show(segue: .webController(url), sender: self)
        }).disposed(by: rx.disposeBag)
    }
}
