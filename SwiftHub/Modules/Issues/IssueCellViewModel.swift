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

class IssueCellViewModel: DefaultTableViewCellViewModel {

    let issue: Issue

    let userSelected = PublishSubject<User>()

    init(with issue: Issue) {
        self.issue = issue
        super.init()
        title.accept(issue.title)
        detail.accept(issue.detail())
        attributedDetail.accept(issue.attributedDetail())
        imageUrl.accept(issue.user?.avatarUrl)
        badge.accept(UIImage(resource: .iconCellBadgeIssue).template)
        badgeColor.accept(issue.state == .open ? UIColor.Material.green : UIColor.Material.red)
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

    func attributedDetail() -> NSAttributedString {
        var texts: [NSAttributedString] = []
        if let commentsString = comments?.string.styled([.foregroundColor: UIColor.text()]) {
            let commentsImage = UIImage(resource: .iconCellBadgeComment).filled(withColor: .secondary()).scaled(toHeight: 15)?.styled([.baselineOffset: -3]) ?? NSAttributedString()
            texts.append(NSAttributedString.composed(of: [
                commentsImage, .space, commentsString, .spacer(width: 10)
            ]))
        }
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
