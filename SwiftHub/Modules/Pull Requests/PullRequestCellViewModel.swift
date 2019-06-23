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
import BonMot

class PullRequestCellViewModel: DefaultTableViewCellViewModel {

    let pullRequest: PullRequest

    let userSelected = PublishSubject<User>()

    init(with pullRequest: PullRequest) {
        self.pullRequest = pullRequest
        super.init()
        title.accept(pullRequest.title)
        detail.accept(pullRequest.detail())
        attributedDetail.accept(pullRequest.attributedDetail())
        imageUrl.accept(pullRequest.user?.avatarUrl)
        badge.accept(R.image.icon_cell_badge_pull_request()?.template)
        badgeColor.accept(pullRequest.state == .open ? UIColor.Material.green : UIColor.Material.purple)
    }
}

extension PullRequest {
    func detail() -> String {
        switch state {
        case .open: return "#\(number ?? 0) opened \(createdAt?.toRelative() ?? "") by \(user?.login ?? "")"
        case .closed: return "#\(number ?? 0) closed \(closedAt?.toRelative() ?? "") by \(user?.login ?? "")"
        case .all: return ""
        }
    }

    func attributedDetail() -> NSAttributedString {
        var texts: [NSAttributedString] = []
        labels?.forEach({ (label) in
            if let name = label.name, let color = UIColor(hexString: label.color ?? "") {
                let labelString = " \(name) ".styled(with: .color(color.darken(by: 0.35).brightnessAdjustedColor),
                                                     .backgroundColor(color),
                                                     .lineHeightMultiple(1.2),
                                                     .baselineOffset(1))
                texts.append(NSAttributedString.composed(of: [
                    labelString, Special.space
                ]))
            }
        })
        return NSAttributedString.composed(of: texts)
    }
}
