//
//  ContactsViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/15/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Contacts
import MessageUI

private let reuseIdentifier = R.reuseIdentifier.contactCell.identifier

class ContactsViewController: TableViewController {

    var viewModel: ContactsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        stackView.insertArrangedSubview(searchBar, at: 0)

        tableView.register(R.nib.contactCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let pullToRefresh = Observable.of(Observable.just(()),
                                          searchBar.rx.cancelButtonClicked.asObservable()).merge()
        let input = ContactsViewModel.Input(cancelTrigger: closeBarButton.rx.tap.asDriver(),
                                            cancelSearchTrigger: searchBar.rx.cancelButtonClicked.asDriver(),
                                            trigger: pullToRefresh,
                                            keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                            selection: tableView.rx.modelSelected(ContactCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

        output.items
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: ContactCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.contactSelected.drive(onNext: { [weak self] (contact) in
            if let strongSelf = self {
                let phone = contact.phones.first ?? ""
                let vc = strongSelf.navigator.toInviteContact(withPhone: phone)
                vc.messageComposeDelegate = self
                if MFMessageComposeViewController.canSendText() {
                    strongSelf.present(vc, animated: true, completion: nil)
                }
            }
        }).disposed(by: rx.disposeBag)
    }
}

extension ContactsViewController: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent: break
        case .failed: break
        case .cancelled: break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
