//
//  SettingThemeCellViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingThemeCellViewModel {

    let title: Driver<String>
    let imageName: Driver<String>
    let showDisclosure: Driver<Bool>
    let isEnabled: Driver<Bool>

    let model: SettingModel

    let nightModeEnabled = PublishSubject<Bool>()

    init(with model: SettingModel, isEnabled: Bool) {
        self.model = model
        title = Driver.just("\(model.title ?? "")")
        imageName = Driver.just("\(model.leftImage ?? "")")
        showDisclosure = Driver.just(model.showDisclosure)
        self.isEnabled = Driver.just(isEnabled)
    }
}
