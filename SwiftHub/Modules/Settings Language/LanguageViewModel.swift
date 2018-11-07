//
//  LanguageViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 3/25/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Localize_Swift

class LanguageViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Observable<Void>
        let saveTrigger: Driver<Void>
        let selection: Driver<LanguageCellViewModel>
    }

    struct Output {
        let items: Driver<[LanguageCellViewModel]>
        let saved: Driver<Void>
    }

    private var currentLanguage: BehaviorRelay<String>

    override init(provider: SwiftHubAPI) {
        currentLanguage = BehaviorRelay(value: Localize.currentLanguage())
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[LanguageCellViewModel]>(value: [])

        input.trigger.map({ () -> [LanguageCellViewModel] in
            let languages = Localize.availableLanguages(true)
            return languages.map({ (language) -> LanguageCellViewModel in
                let viewModel = LanguageCellViewModel(with: language)
                return viewModel
            })
        }).bind(to: elements).disposed(by: rx.disposeBag)

        let saved = input.saveTrigger.map { () -> Void in
            let language = self.currentLanguage.value
            Localize.setCurrentLanguage(language)
            analytics.log(.appLanguage(language: language))
        }

        input.selection.drive(onNext: { (cellViewModel) in
            let language = cellViewModel.language
            self.currentLanguage.accept(language)
        }).disposed(by: rx.disposeBag)

        return Output(items: elements.asDriver(),
                      saved: saved.asDriver(onErrorJustReturn: ()))
    }
}
