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
import AttributedLib

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
        let text = NSMutableAttributedString(string: "")

        let textAttributes = Attributes {
            return $0.foreground(color: themeService.attrs.text)
        }

        if let followers = followers {
            let followersString = followers.kFormatted()
            text.append("\(followersString) \(R.string.localizable.userFollowersButtonTitle.key.localized())\t".at.attributed(with: textAttributes))
        }

        if let repositories = repositoriesCount {
            let repositoriesString = repositories.kFormatted()
            text.append("\(repositoriesString) \(R.string.localizable.userRepositoriesButtonTitle.key.localized())".at.attributed(with: textAttributes))
        }

        return text
    }
}
