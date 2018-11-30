//
//  PullRequestCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class PullRequestCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<String>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let pullRequest: PullRequest

    init(with pullRequest: PullRequest) {
        self.pullRequest = pullRequest
        title = Driver.just("\(pullRequest.title ?? "")")
        detail = Driver.just("\(pullRequest.createdAt?.toRelative() ?? "")")
        secondDetail = Driver.just("#\(pullRequest.number ?? 0)")
        imageUrl = Driver.just(pullRequest.user?.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_pull_request()?.template)
        badgeColor = Driver.just(pullRequest.state == .open ? .flatGreenDark : .flatPurpleDark)
    }
}
