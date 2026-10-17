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
        badge.accept(UIImage(resource: .iconCellBadgePullRequest).template)
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
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 1.2
                let labelString = " \(name) ".styled([.foregroundColor: color.darken(by: 0.35).brightnessAdjustedColor,
                                                      .backgroundColor: color,
                                                      .paragraphStyle: paragraphStyle,
                                                      .baselineOffset: 1])
                texts.append(NSAttributedString.composed(of: [
                    labelString, .space
                ]))
            }
        })
        return NSAttributedString.composed(of: texts)
    }
}
