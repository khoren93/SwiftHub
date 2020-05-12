//
//  ContributionsCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/12/20.
//  Copyright © 2020 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ContributionsCellViewModel: TableViewCellViewModel {

    let contributionCalendar = BehaviorRelay<ContributionCalendar?>(value: nil)

    init(with contributionCalendar: ContributionCalendar) {
        super.init()
        self.contributionCalendar.accept(contributionCalendar)
    }
}
