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
    let detail: Driver<String>
    let image: Driver<UIImage?>
    let showDisclosure: Driver<Bool>

    init(with title: String, detail: String, image: UIImage?) {
        self.title = Driver.just(title)
        self.detail = Driver.just(detail)
        self.image = Driver.just(image)
        showDisclosure = Driver.just(true)
    }
}
