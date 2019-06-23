//
//  SettingSwitchCellViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingSwitchCellViewModel: DefaultTableViewCellViewModel {

    let isEnabled = BehaviorRelay<Bool>(value: false)

    let switchChanged = PublishSubject<Bool>()

    init(with title: String, detail: String?, image: UIImage?, hidesDisclosure: Bool, isEnabled: Bool) {
        super.init()
        self.title.accept(title)
        self.secondDetail.accept(detail)
        self.image.accept(image)
        self.hidesDisclosure.accept(hidesDisclosure)
        self.isEnabled.accept(isEnabled)
    }
}
