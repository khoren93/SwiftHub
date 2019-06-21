//
//  CommitCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class CommitCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<String>
    let imageUrl: Driver<URL?>
    let badge: Driver<UIImage?>
    let badgeColor: Driver<UIColor>

    let commit: Commit

    let userSelected = PublishSubject<User>()

    init(with commit: Commit) {
        self.commit = commit
        title = Driver.just("\(commit.commit?.message ?? "")")
        detail = Driver.just("\(commit.commit?.committer?.date?.toRelative() ?? "")")
        secondDetail = Driver.just("\(commit.sha?.slicing(from: 0, length: 7) ?? "")")
        imageUrl = Driver.just(commit.committer?.avatarUrl?.url)
        badge = Driver.just(R.image.icon_cell_badge_commit()?.template)
        badgeColor = Driver.just(UIColor.Material.green)
    }
}
