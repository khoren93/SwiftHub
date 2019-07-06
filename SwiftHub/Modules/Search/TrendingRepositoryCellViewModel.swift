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
import BonMot

class TrendingRepositoryCellViewModel: DefaultTableViewCellViewModel {

    let repository: TrendingRepository

    init(with repository: TrendingRepository, since: TrendingPeriodSegments) {
        self.repository = repository
        super.init()
        title.accept(repository.fullname)
        detail.accept(repository.descriptionField)
        attributedDetail.accept(repository.attributetDetail(since: since.title))
        imageUrl.accept(repository.avatarUrl)
        badge.accept(R.image.icon_cell_badge_repository()?.template)
        badgeColor.accept(UIColor.Material.green900)
    }
}

extension TrendingRepositoryCellViewModel {
    static func == (lhs: TrendingRepositoryCellViewModel, rhs: TrendingRepositoryCellViewModel) -> Bool {
        return lhs.repository == rhs.repository
    }
}

extension TrendingRepository {
    func attributetDetail(since: String) -> NSAttributedString {
        let starImage = R.image.icon_cell_badge_star()?.filled(withColor: .text()).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
        let starsString = (stars ?? 0).kFormatted().styled( with: .color(UIColor.text()))
        let currentPeriodStarsString = "\((currentPeriodStars ?? 0).kFormatted()) \(since.lowercased())".styled( with: .color(UIColor.text()))
        let languageColorShape = "●".styled(with: StringStyle([.color(UIColor(hexString: languageColor ?? "") ?? .clear)]))
        let languageString = (language ?? "").styled( with: .color(UIColor.text()))
        return NSAttributedString.composed(of: [
            starImage, Special.space, starsString, Special.space, Special.tab,
            starImage, Special.space, currentPeriodStarsString, Special.space, Special.tab,
            languageColorShape, Special.space, languageString
        ])
    }
}
