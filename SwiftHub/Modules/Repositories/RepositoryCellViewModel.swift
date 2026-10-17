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
        badge.accept(UIImage(resource: .iconCellBadgeRepository).template)
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

        let starsString = (stargazersCount ?? 0).kFormatted().styled([.foregroundColor: UIColor.text()])
        let starsImage = UIImage(resource: .iconCellBadgeStar).filled(withColor: UIColor.text()).scaled(toHeight: 15)?.styled([.baselineOffset: -3]) ?? NSAttributedString()
        texts.append(NSAttributedString.composed(of: [
            starsImage, .space, starsString, .space, .tab
            ]))

        if let languageString = language?.styled([.foregroundColor: UIColor.text()]) {
            let languageColorShape = "●".styled([.foregroundColor: UIColor(hexString: languageColor ?? "") ?? .clear])
            texts.append(NSAttributedString.composed(of: [
                languageColorShape, .space, languageString
                ]))
        }

        return NSAttributedString.composed(of: texts)
    }
}
