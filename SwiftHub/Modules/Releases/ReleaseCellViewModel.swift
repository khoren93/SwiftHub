//
//  ReleaseCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/12/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReleaseCellViewModel {
    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<String>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let release: Release

    let userSelected = PublishSubject<User>()

    init(with release: Release) {
        self.release = release
        title = Driver.just("\(release.tagName ?? "") - \(release.name ?? "")")
        detail = Driver.just("\(release.publishedAt?.toRelative() ?? "")")
        secondDetail = Driver.just("\(release.body ?? "")")
        imageUrl = Driver.just(release.author?.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_tag()?.template)
        badgeColor = Driver.just(UIColor.Material.green)
    }
}
