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

class BranchCellViewModel: DefaultTableViewCellViewModel {

    let branch: Branch

    init(with branch: Branch) {
        self.branch = branch
        super.init()
        title.accept(branch.name)
        image.accept(UIImage(resource: .iconCellGitBranch).template)
    }
}
