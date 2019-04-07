//
//  BranchCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/6/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BranchCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let secondDetail: Driver<String>
    let image: Driver<UIImage?>

    let branch: Branch

    let userSelected = PublishSubject<User>()

    init(with branch: Branch) {
        self.branch = branch
        title = Driver.just("\(branch.name ?? "")")
        detail = Driver.just("")
        secondDetail = Driver.just("")
        image = Driver.just(R.image.icon_cell_git_branch()?.template)
    }
}
