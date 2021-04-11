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

class ContributionsCellViewModel: DefaultTableViewCellViewModel {

    let contributionCalendar = BehaviorRelay<ContributionCalendar?>(value: nil)

    init(with title: String, detail: String, image: UIImage?, contributionCalendar: ContributionCalendar?) {
        super.init()
        self.title.accept(title)
        self.secondDetail.accept(detail)
        self.image.accept(image)
        self.contributionCalendar.accept(contributionCalendar)
    }
}
