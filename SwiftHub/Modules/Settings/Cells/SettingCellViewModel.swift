//
//  SettingCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingCellViewModel {

    let title: Driver<String>
    let imageName: Driver<String>
    let showDisclosure: Driver<Bool>

    let model: SettingModel

    init(with model: SettingModel) {
        self.model = model
        title = Driver.just("\(model.title ?? "")")
        imageName = Driver.just("\(model.leftImage ?? "")")
        showDisclosure = Driver.just(model.showDisclosure)
    }
}
