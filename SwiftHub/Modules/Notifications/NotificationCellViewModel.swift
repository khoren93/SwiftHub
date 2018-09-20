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

class NotificationCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let imageUrl: Driver<URL?>

    let notification: Notification

    let userSelected = PublishSubject<User>()

    init(with notification: Notification) {
        self.notification = notification

        let actionText = notification.subject?.title ?? ""
        let repoName = notification.repository?.fullName ?? ""

        title = Driver.just([repoName, actionText].joined(separator: "\n"))
        detail = Driver.just("\(notification.updatedAt?.toRelative() ?? "")")
        imageUrl = Driver.just(notification.repository?.owner?.avatarUrl?.url)
    }
}

extension NotificationCellViewModel: Equatable {
    static func == (lhs: NotificationCellViewModel, rhs: NotificationCellViewModel) -> Bool {
        return lhs.notification == rhs.notification
    }
}
