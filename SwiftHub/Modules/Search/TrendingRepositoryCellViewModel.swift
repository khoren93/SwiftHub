//
//  TrendingRepositoryCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/18/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class TrendingRepositoryCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<String>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let repository: TrendingRepository

    init(with repository: TrendingRepository, since: TrendingPeriodSegments) {
        self.repository = repository
        title = Driver.just("\(repository.fullname ?? "")")
        detail = Driver.just("\(repository.descriptionField ?? "")")
        secondDetail = Driver.just("★ \(repository.stars ?? 0) \t★ \(repository.currentPeriodStars ?? 0) \(since.title.lowercased()) \t\(repository.language ?? "")")
        imageUrl = Driver.just(repository.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_repository()?.template)
        badgeColor = Driver.just(UIColor.flatGreenDark)
    }
}

extension TrendingRepositoryCellViewModel: Equatable {
    static func == (lhs: TrendingRepositoryCellViewModel, rhs: TrendingRepositoryCellViewModel) -> Bool {
        return lhs.repository == rhs.repository
    }
}
