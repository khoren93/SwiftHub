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

    let settingModel: SettingModel
    let destinationViewModel: Any?

    let nightModeEnabled = PublishSubject<Bool>()

    init(with settingModel: SettingModel, isEnabled: Bool, destinationViewModel: Any?) {
        self.destinationViewModel = destinationViewModel
        self.settingModel = settingModel
        title = Driver.just("\(settingModel.title ?? "")")
        imageName = Driver.just("\(settingModel.leftImage ?? "")")
        showDisclosure = Driver.just(settingModel.showDisclosure)
        self.isEnabled = Driver.just(isEnabled)
    }
}
