//
//  TrendingUserCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/18/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrendingUserCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let user: TrendingUser

    init(with user: TrendingUser) {
        self.user = user
        title = Driver.just("\(user.username ?? "") (\(user.name ?? ""))")
        detail = Driver.just("\((user.repo?.fullname ?? ""))")
        imageUrl = Driver.just(user.avatar?.url)
        badge = Driver.just(R.image.icon_cell_badge_user()?.template)
        badgeColor = Driver.just(UIColor.Material.green900)
    }
}

extension TrendingUserCellViewModel: Equatable {
    static func == (lhs: TrendingUserCellViewModel, rhs: TrendingUserCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }
}
