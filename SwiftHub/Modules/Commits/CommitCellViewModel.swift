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

class CommitCellViewModel: DefaultTableViewCellViewModel {

    let commit: Commit

    let userSelected = PublishSubject<User>()

    init(with commit: Commit) {
        self.commit = commit
        super.init()
        title.accept(commit.commit?.message)
        detail.accept(commit.commit?.committer?.date?.toRelative())
        secondDetail.accept(commit.sha?.slicing(from: 0, length: 7))
        imageUrl.accept(commit.committer?.avatarUrl)
        badge.accept(R.image.icon_cell_badge_commit()?.template)
        badgeColor.accept(UIColor.Material.green)
    }
}
