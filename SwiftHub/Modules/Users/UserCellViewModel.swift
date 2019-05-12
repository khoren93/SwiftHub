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
import BonMot

class UserCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<NSAttributedString?>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>
    let following: Driver<Bool>
    let hidesFollowButton: Driver<Bool>

    let user: User

    init(with user: User) {
        self.user = user
        title = Driver.just("\(user.login ?? "")")
        detail = Driver.just("\((user.contributions != nil) ? "\(user.contributions ?? 0) commits": (user.name ?? ""))")
        secondDetail = Driver.just(user.attributetDetail())
        imageUrl = Driver.just(user.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_user()?.template)
        badgeColor = Driver.just(UIColor.flatGreenDark)
        following = Driver.just(user.viewerIsFollowing).filterNil()
        hidesFollowButton = loggedIn.map({ loggedIn -> Bool in
            if loggedIn == false { return true }
            if let viewerCanFollow = user.viewerCanFollow { return !viewerCanFollow }
            return true
        }).asDriver(onErrorJustReturn: false)
    }
}

extension UserCellViewModel: Equatable {
    static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }
}

extension User {
    func attributetDetail() -> NSAttributedString? {
        var texts: [NSAttributedString] = []
        if let repositoriesString = repositoriesCount?.string.styled( with: .color(.text())) {
            let repositoriesImage = R.image.icon_cell_badge_repository()?.filled(withColor: .text()).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
            texts.append(NSAttributedString.composed(of: [
                repositoriesImage, Special.space, repositoriesString, Special.space, Special.tab
            ]))
        }
        if let followersString = followers?.kFormatted().styled( with: .color(.text())) {
            let followersImage = R.image.icon_cell_badge_collaborator()?.filled(withColor: .text()).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
            texts.append(NSAttributedString.composed(of: [
                followersImage, Special.space, followersString
            ]))
        }
        return NSAttributedString.composed(of: texts)
    }
}
