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
import AttributedLib

class RepositoryCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<NSAttributedString>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let repository: Repository

    init(with repository: Repository) {
        self.repository = repository
        title = Driver.just("\(repository.fullname ?? "")")
        detail = Driver.just("\(repository.descriptionField ?? "")")
        secondDetail = Driver.just(repository.attributetDetail())
        imageUrl = Driver.just(repository.owner?.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_repository()?.template)
        badgeColor = Driver.just(UIColor.flatGreenDark)
    }
}

extension RepositoryCellViewModel: Equatable {
    static func == (lhs: RepositoryCellViewModel, rhs: RepositoryCellViewModel) -> Bool {
        return lhs.repository == rhs.repository
    }
}

extension Repository {
    func attributetDetail() -> NSAttributedString {
        let starsString = (stargazersCount ?? 0).kFormatted()

        let textAttributes = Attributes {
            return $0.foreground(color: themeService.attrs.text)
        }

        let languageColorAttributes = Attributes {
            return $0.foreground(color: UIColor(hexString: languageColor ?? "") ?? .clear)
        }

        return "★ \(starsString) \t".at.attributed(with: textAttributes) +
            "● ".at.attributed(with: languageColorAttributes) + "\(language ?? "")".at.attributed(with: textAttributes)
    }
}
