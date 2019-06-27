//
//  NotificationCellViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 9/19/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class NotificationCellViewModel: DefaultTableViewCellViewModel {

    let notification: Notification

    let userSelected = PublishSubject<User>()

    init(with notification: Notification) {
        self.notification = notification
        super.init()
        let actionText = notification.subject?.title ?? ""
        let repoName = notification.repository?.fullname ?? ""
        title.accept([repoName, actionText].joined(separator: "\n"))
        detail.accept(notification.updatedAt?.toRelative())
        imageUrl.accept(notification.repository?.owner?.avatarUrl)
    }
}

extension NotificationCellViewModel {
    static func == (lhs: NotificationCellViewModel, rhs: NotificationCellViewModel) -> Bool {
        return lhs.notification == rhs.notification
    }
}
