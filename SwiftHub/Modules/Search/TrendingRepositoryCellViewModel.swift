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

class TrendingRepositoryCellViewModel: DefaultTableViewCellViewModel {

    let repository: TrendingRepository

    init(with repository: TrendingRepository, since: TrendingPeriodSegments) {
        self.repository = repository
        super.init()
        title.accept(repository.fullname)
        detail.accept(repository.descriptionField)
        attributedDetail.accept(repository.attributetDetail(since: since.title))
        imageUrl.accept(repository.avatarUrl)
        badge.accept(UIImage(resource: .iconCellBadgeRepository).template)
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
        let starImage = UIImage(resource: .iconCellBadgeStar).filled(withColor: .text()).scaled(toHeight: 15)?.styled([.baselineOffset: -3]) ?? NSAttributedString()
        let starsString = (stars ?? 0).kFormatted().styled([.foregroundColor: UIColor.text()])
        let currentPeriodStarsString = "\((currentPeriodStars ?? 0).kFormatted()) \(since.lowercased())".styled([.foregroundColor: UIColor.text()])
        let languageColorShape = "●".styled([.foregroundColor: UIColor(hexString: languageColor ?? "") ?? .clear])
        let languageString = (language ?? "").styled([.foregroundColor: UIColor.text()])
        return NSAttributedString.composed(of: [
            starImage, .space, starsString, .space, .tab,
            starImage, .space, currentPeriodStarsString, .space, .tab,
            languageColorShape, .space, languageString
        ])
    }
}
