//
//  RepositoryCellViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import BonMot

class RepositoryCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<NSAttributedString?>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>
    let starring: Driver<Bool>
    let hidesStarButton: Driver<Bool>

    let repository: Repository

    init(with repository: Repository) {
        self.repository = repository
        title = Driver.just("\(repository.fullname ?? "")")
        detail = Driver.just("\(repository.descriptionField ?? "")")
        secondDetail = Driver.just(repository.attributetDetail())
        imageUrl = Driver.just(repository.owner?.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_repository()?.template)
        badgeColor = Driver.just(UIColor.flatGreenDark)
        starring = Driver.just(repository.viewerHasStarred).filterNil()
        hidesStarButton = loggedIn.map { !$0 || repository.viewerHasStarred == nil }.asDriver(onErrorJustReturn: false)
    }
}

extension RepositoryCellViewModel: Equatable {
    static func == (lhs: RepositoryCellViewModel, rhs: RepositoryCellViewModel) -> Bool {
        return lhs.repository == rhs.repository
    }
}

extension Repository {
    func attributetDetail() -> NSAttributedString? {
        let starImage = R.image.icon_cell_badge_star()?.filled(withColor: .text()).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
        let starsString = (stargazersCount ?? 0).kFormatted()
        let languageColorShape = "●".styled(with: StringStyle([.color(UIColor(hexString: languageColor ?? "") ?? .clear)]))
        return NSAttributedString.composed(of: [
            starImage, Special.space, starsString, Special.space, Special.tab,
            languageColorShape, Special.space, language ?? ""
        ])
    }
}
