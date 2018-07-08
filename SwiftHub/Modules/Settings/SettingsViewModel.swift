//
//  SettingsViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class SettingsViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Driver<Void>
        let selection: Driver<SettingCellViewModel>
    }

    struct Output {
        let items: Driver<[SectionType<SettingCellViewModel>]>
        let selectedEvent: Driver<SettingCellViewModel>
    }

    func transform(input: Input) -> Output {

        let items = input.trigger
            .flatMapLatest { (_) -> SharedSequence<DriverSharingStrategy, [SectionType<SettingCellViewModel>]> in
                let removeCacheCellViewModel = SettingModel(type: .removeCache, leftImage: R.image.icon_favorite.name, title: "Remove Cache", detail: "", showDisclosure: false)

                let acknowledgementsCellViewModel = SettingModel(type: .acknowledgements, leftImage: R.image.icon_favorite.name, title: "Acknowledgements", detail: "", showDisclosure: true)

                return Observable.of([
                    SectionType<SettingCellViewModel>(header: "Preferences", items: [
                        SettingCellViewModel(with: removeCacheCellViewModel, destinationViewModel: nil)
                        ]),
                    SectionType<SettingCellViewModel>(header: "Support", items: [
                        SettingCellViewModel(with: acknowledgementsCellViewModel, destinationViewModel: nil)
                        ])
                    ])
                    .asDriverOnErrorJustComplete()
        }

        let selectedEvent = input.selection

        return Output(items: items,
                      selectedEvent: selectedEvent)
    }
}
