//
//  UserDetailCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 10/13/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserDetailCellViewModel {

    let title: Driver<String>
    let image: Driver<UIImage?>
    let showDisclosure: Driver<Bool>

    let destinationViewModel: Any?

    init(with title: String, image: UIImage?, destinationViewModel: Any?) {
        self.destinationViewModel = destinationViewModel

        self.title = Driver.just(title)
        self.image = Driver.just(image)
        showDisclosure = Driver.just(true)
    }
}
