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

class ContactCellViewModel: DefaultTableViewCellViewModel {

    let contact: Contact

    init(with contact: Contact) {
        self.contact = contact
        super.init()
        title.accept(contact.name)
        let info = contact.phones + contact.emails
        detail.accept(info.joined(separator: ", "))
        image.accept(UIImage(data: contact.imageData ?? Data()) ?? R.image.icon_cell_contact_no_image()?.template)
    }
}
