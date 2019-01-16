//
//  ContactCellViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/15/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ContactCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let image: Driver<UIImage?>

    let contact: Contact

    init(with contact: Contact) {
        self.contact = contact

        self.title = Driver.just("\(contact.name ?? "")")
        let info = contact.phones + contact.emails
        self.detail = Driver.just(info.joined(separator: ", "))
        self.image = Driver.just(UIImage(data: contact.imageData ?? Data()) ?? R.image.icon_cell_badge_user()?.template)
    }
}
