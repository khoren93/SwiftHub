//
//  IssueCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class IssueCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let issue: Issue

    let userSelected = PublishSubject<User>()

    init(with issue: Issue) {
        self.issue = issue
        title = Driver.just("\(issue.title ?? "")")
        detail = Driver.just(issue.detail())
        imageUrl = Driver.just(issue.user?.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_issue()?.template)
        badgeColor = Driver.just(issue.state == .open ? .flatGreenDark : .flatRedDark)
    }
}

extension Issue {
    func detail() -> String {
        switch state {
        case .open: return "#\(number ?? 0) opened \(createdAt?.toRelative() ?? "") by \(user?.login ?? "")"
        case .closed: return "#\(number ?? 0) closed \(closedAt?.toRelative() ?? "") by \(user?.login ?? "")"
        case .all: return ""
        }
    }
}
