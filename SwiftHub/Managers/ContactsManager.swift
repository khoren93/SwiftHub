//
//  ContactsManager.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/15/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Contacts

typealias ContactsHandler = (_ contacts: [CNContact], _ error: NSError?) -> Void

enum ContactsError: Error {
    case accessDenied
}

class ContactsManager: NSObject {

    static let `default` = ContactsManager()

    let contactsStore = CNContactStore()

    // MARK: - Contact Operations

    func getContacts(with keyword: String = "") -> Observable<[Contact]> {
        return Single.create { single in
            switch CNContactStore.authorizationStatus(for: CNEntityType.contacts) {
            case CNAuthorizationStatus.denied, CNAuthorizationStatus.restricted:
                // User has denied the current app to access the contacts.
                single(.failure(ContactsError.accessDenied))

            case CNAuthorizationStatus.notDetermined:
                // This case means the user is prompted for the first time for allowing contacts
                self.contactsStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (granted, error) -> Void in
                    // At this point an alert is provided to the user to provide access to contacts. This will get invoked if a user responds to the alert
                    if granted {
                        self.getContacts().subscribe(onNext: { (newContacts) in
                            single(.success(newContacts))
                        }).disposed(by: self.rx.disposeBag)
                    } else if let error = error {
                        single(.failure(error))
                    }
                })

            case  CNAuthorizationStatus.authorized:
                // Authorization granted by user for this app.
                var contactsArray = [CNContact]()
                let contactFetchRequest = CNContactFetchRequest(keysToFetch: self.allowedContactKeys())
                contactFetchRequest.sortOrder = .givenName
                do {
                    try self.contactsStore.enumerateContacts(with: contactFetchRequest, usingBlock: { (contact, stop) -> Void in
                        contactsArray.append(contact)
                    })

                    single(.success(contactsArray.map { Contact(with: $0) }.filter({ (contact) -> Bool in
                        if let name = contact.name, !keyword.isEmpty {
                            return name.contains(keyword, caseSensitive: false)
                        }
                        return true
                    })))
                }
                    // Catching exception as enumerateContactsWithFetchRequest can throw errors
                catch {
                    single(.failure(error))
                    logError(error.localizedDescription)
                }
            @unknown default: break
            }
            return Disposables.create { }
            }.asObservable()
    }

    /// We have to provide only the keys which we have to access. We should avoid unnecessary keys when fetching the contact. Reducing the keys means faster the access.
    ///
    /// - Returns: The allowed keys
    func allowedContactKeys() -> [CNKeyDescriptor] {
        return [CNContactNamePrefixKey as CNKeyDescriptor,
                CNContactGivenNameKey as CNKeyDescriptor,
                CNContactFamilyNameKey as CNKeyDescriptor,
                CNContactOrganizationNameKey as CNKeyDescriptor,
                CNContactBirthdayKey as CNKeyDescriptor,
                CNContactImageDataKey as CNKeyDescriptor,
                CNContactThumbnailImageDataKey as CNKeyDescriptor,
                CNContactImageDataAvailableKey as CNKeyDescriptor,
                CNContactPhoneNumbersKey as CNKeyDescriptor,
                CNContactEmailAddressesKey as CNKeyDescriptor
        ]
    }
}
