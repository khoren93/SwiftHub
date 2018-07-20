//
//  LoginViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/12/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LoginViewModel: ViewModel, ViewModelType {

    struct Input {
        let loginTrigger: Driver<Void>
    }

    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<Error>
        let loginButtonEnabled: Driver<Bool>
    }

    let email = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")

    let loginEvent = PublishSubject<Bool>()

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let inputs = BehaviorRelay.combineLatest(email, password)

        let loginButtonEnabled = BehaviorRelay.combineLatest(inputs, activityIndicator.asObservable()) {
            return $0.0.isNotEmpty && $0.1.isNotEmpty && !$1
        }.asDriver(onErrorJustReturn: false)

//        input.loginTrigger.map { true }.asObservable().bind(to: loginEvent).disposed(by: rx.disposeBag)
        input.loginTrigger.drive(onNext: { () in
            themeService.set(index: themeService.index == 0 ? 1 : 0)
        }).disposed(by: rx.disposeBag)

        return Output(fetching: fetching,
                      error: errors,
                      loginButtonEnabled: loginButtonEnabled)
    }
}
