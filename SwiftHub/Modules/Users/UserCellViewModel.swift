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

class UserCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let user: User

    init(with user: User) {
        self.user = user
        title = Driver.just("\(user.login ?? "")")
        detail = Driver.just("\(user.name ?? "")")
        imageUrl = Driver.just(user.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_user()?.template)
        badgeColor = Driver.just(UIColor.flatGreenDark)
    }
}

extension UserCellViewModel: Equatable {
    static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }
}
