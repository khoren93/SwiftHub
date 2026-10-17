//
//  UserCellViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserCellViewModel: DefaultTableViewCellViewModel {

    let following = BehaviorRelay<Bool>(value: false)
    let hidesFollowButton = BehaviorRelay<Bool>(value: true)

    let user: User

    init(with user: User) {
        self.user = user
        super.init()
        title.accept(user.login)
        detail.accept("\((user.contributions != nil) ? "\(user.contributions ?? 0) commits": (user.name ?? ""))")
        attributedDetail.accept(user.attributetDetail())
        imageUrl.accept(user.avatarUrl)
        badge.accept(UIImage(resource: .iconCellBadgeUser).template)
        badgeColor.accept(UIColor.Material.green900)

        following.accept(user.viewerIsFollowing ?? false)
        loggedIn.map({ loggedIn -> Bool in
            if loggedIn == false { return true }
            if let viewerCanFollow = user.viewerCanFollow { return !viewerCanFollow }
            return true
        }).bind(to: hidesFollowButton).disposed(by: rx.disposeBag)
    }
}

extension UserCellViewModel {
    static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }
}

extension User {
    func attributetDetail() -> NSAttributedString? {
        var texts: [NSAttributedString] = []
        if let repositoriesString = repositoriesCount?.string.styled([.foregroundColor: UIColor.text()]) {
            let repositoriesImage = UIImage(resource: .iconCellBadgeRepository).filled(withColor: UIColor.text()).scaled(toHeight: 15)?.styled([.baselineOffset: -3]) ?? NSAttributedString()
            texts.append(NSAttributedString.composed(of: [
                repositoriesImage, .space, repositoriesString, .space, .tab
            ]))
        }
        if let followersString = followers?.kFormatted().styled([.foregroundColor: UIColor.text()]) {
            let followersImage = UIImage(resource: .iconCellBadgeCollaborator).filled(withColor: UIColor.text()).scaled(toHeight: 15)?.styled([.baselineOffset: -3]) ?? NSAttributedString()
            texts.append(NSAttributedString.composed(of: [
                followersImage, .space, followersString
            ]))
        }
        return NSAttributedString.composed(of: texts)
    }
}
