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

class RepositoryCellViewModel: DefaultTableViewCellViewModel {

    let starring = BehaviorRelay<Bool>(value: false)
    let hidesStarButton = BehaviorRelay<Bool>(value: true)

    let repository: Repository

    init(with repository: Repository) {
        self.repository = repository
        super.init()
        title.accept(repository.fullname)
        detail.accept(repository.descriptionField)
        attributedDetail.accept(repository.attributetDetail())
        imageUrl.accept(repository.owner?.avatarUrl)
        badge.accept(R.image.icon_cell_badge_repository()?.template)
        badgeColor.accept(UIColor.Material.green900)

        starring.accept(repository.viewerHasStarred ?? false)
        loggedIn.map { !$0 || repository.viewerHasStarred == nil }.bind(to: hidesStarButton).disposed(by: rx.disposeBag)
    }
}

extension RepositoryCellViewModel {
    static func == (lhs: RepositoryCellViewModel, rhs: RepositoryCellViewModel) -> Bool {
        return lhs.repository == rhs.repository
    }
}

extension Repository {
    func attributetDetail() -> NSAttributedString? {
        var texts: [NSAttributedString] = []

        let starsString = (stargazersCount ?? 0).kFormatted().styled( with: .color(UIColor.text()))
        let starsImage = R.image.icon_cell_badge_star()?.filled(withColor: UIColor.text()).scaled(toHeight: 15)?.styled(with: .baselineOffset(-3)) ?? NSAttributedString()
        texts.append(NSAttributedString.composed(of: [
            starsImage, Special.space, starsString, Special.space, Special.tab
            ]))

        if let languageString = language?.styled( with: .color(UIColor.text())) {
            let languageColorShape = "●".styled(with: StringStyle([.color(UIColor(hexString: languageColor ?? "") ?? .clear)]))
            texts.append(NSAttributedString.composed(of: [
                languageColorShape, Special.space, languageString
                ]))
        }

        return NSAttributedString.composed(of: texts)
    }
}
