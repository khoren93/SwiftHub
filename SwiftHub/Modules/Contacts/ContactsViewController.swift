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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationTitle = R.string.localizable.contactsNavigationTitle.key.localized()
        emptyDataSetTitle = R.string.localizable.contactsPermissionDeniedTitle.key.localized()
        emptyDataSetDescription = R.string.localizable.contactsPermissionDeniedDescription.key.localized()
        stackView.insertArrangedSubview(searchBar, at: 0)

        tableView.register(R.nib.contactCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? ContactsViewModel else { return }

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

        emptyDataSetButtonTap.subscribe(onNext: { () in
            let app = UIApplication.shared
            if let settingsUrl = UIApplication.openSettingsURLString.url, app.canOpenURL(settingsUrl) {
                app.open(settingsUrl, completionHandler: nil)
            }
        }).disposed(by: rx.disposeBag)
    }
}

extension ContactsViewController {
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
        return NSAttributedString(string: R.string.localizable.contactsPermissionDeniedButton.key.localized(),
                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondary()])
    }
}

extension ContactsViewController: MFMessageComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .sent:
            analytics.log(.userInvited(success: true))
        case .failed:
            analytics.log(.userInvited(success: false))
        case .cancelled: break
        @unknown default: break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
