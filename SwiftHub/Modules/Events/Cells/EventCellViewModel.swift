//
//  EventCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EventCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let imageUrl: Driver<URL?>

    let event: Event

    let userSelected = PublishSubject<User>()

    init(with event: Event) {
        self.event = event

        let actorName = event.actor?.login ?? ""

        var actionText = ""
        switch event.type {
        case .fork: actionText = "forked"
        case .create: actionText = "created" + " " + ((event.payload as? CreatePayload)?.refType ?? "")
        case .star: actionText = "starred"
        default: break
        }

        let repoName = event.repository?.fullName ?? ""

        title = Driver.just([actorName, actionText, repoName].joined(separator: " "))
        detail = Driver.just("\(event.createdAt?.toRelative() ?? "")")
        imageUrl = Driver.just(event.actor?.avatarUrl?.url)
    }
}

extension EventCellViewModel: Equatable {
    static func == (lhs: EventCellViewModel, rhs: EventCellViewModel) -> Bool {
        return lhs.event == rhs.event
    }
}
