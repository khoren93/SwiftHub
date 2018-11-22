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
        case .fork:
            actionText = "forked"
        case .create:
            let payload = event.payload as? CreatePayload
            actionText = ["created", (payload?.refType ?? ""), (payload?.ref ?? ""), "in"].joined(separator: " ")
        case .issueComment:
            let payload = event.payload as? IssueCommentPayload
            actionText = ["commented on issue", "#\(payload?.issue?.number ?? 0)", "at"].joined(separator: " ")
        case .issues:
            let payload = event.payload as? IssuesPayload
            actionText = [(payload?.action ?? ""), "issue", "in"].joined(separator: " ")
        case .member:
            let payload = event.payload as? MemberPayload
            actionText = [(payload?.action ?? ""), "\(payload?.member?.login ?? "")", "as a collaborator to"].joined(separator: " ")
        case .pullRequest:
            let payload = event.payload as? PullRequestPayload
            actionText = [(payload?.action ?? ""), "pull request", "#\(payload?.number ?? 0)", "in"].joined(separator: " ")
        case .push:
            let payload = event.payload as? PushPayload
            actionText = ["pushed to", payload?.ref ?? "", "at"].joined(separator: " ")
        case .star:
            actionText = "starred"
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
