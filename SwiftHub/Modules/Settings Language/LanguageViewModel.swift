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
        let fetching: Driver<Bool>
        let items: Driver<[LanguageCellViewModel]>
        let saved: Driver<Void>
        let dismiss: Driver<Void>
        let error: Driver<Error>
    }

    private var currentLanguage: BehaviorRelay<String>

    override init(provider: SwiftHubAPI) {
        currentLanguage = BehaviorRelay(value: Localize.currentLanguage())
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let elements = BehaviorRelay<[LanguageCellViewModel]>(value: [])

        input.trigger.map({ () -> [LanguageCellViewModel] in
            let languages = Localize.availableLanguages(true)
            return languages.map({ (language) -> LanguageCellViewModel in
                let viewModel = LanguageCellViewModel(with: language)
                return viewModel
            })
        }).bind(to: elements).disposed(by: rx.disposeBag)

        let saved = input.saveTrigger.map { () -> Void in
            Localize.setCurrentLanguage(self.currentLanguage.value)
        }

        input.selection.drive(onNext: { (cellViewModel) in
            let language = cellViewModel.language
            self.currentLanguage.accept(language)
        }).disposed(by: rx.disposeBag)

        let dismiss = Observable.of(saved).merge().asDriver(onErrorJustReturn: ())

        return Output(fetching: fetching,
                      items: elements.asDriver(),
                      saved: saved.asDriver(onErrorJustReturn: ()),
                      dismiss: dismiss,
                      error: errors)
    }
}
