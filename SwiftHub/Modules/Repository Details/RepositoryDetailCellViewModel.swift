//
//  RepositoryDetailCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RepositoryDetailCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let image: Driver<UIImage?>
    let hidesDisclosure: Driver<Bool>

    init(with title: String, detail: String, image: UIImage?, hidesDisclosure: Bool) {
        self.title = Driver.just(title)
        self.detail = Driver.just(detail)
        self.image = Driver.just(image)
        self.hidesDisclosure = Driver.just(hidesDisclosure)
    }
}
