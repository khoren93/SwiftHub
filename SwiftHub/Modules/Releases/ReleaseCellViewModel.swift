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

class ReleaseCellViewModel: DefaultTableViewCellViewModel {

    let release: Release

    let userSelected = PublishSubject<User>()

    init(with release: Release) {
        self.release = release
        super.init()
        title.accept("\(release.tagName ?? "") - \(release.name ?? "")")
        detail.accept(release.publishedAt?.toRelative())
        secondDetail.accept(release.body)
        imageUrl.accept(release.author?.avatarUrl)
        badge.accept(R.image.icon_cell_badge_tag()?.template)
        badgeColor.accept(UIColor.Material.green)
    }
}
