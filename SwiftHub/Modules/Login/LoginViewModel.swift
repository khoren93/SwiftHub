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
        let loginTriggered: Driver<Void>
    }

    let loginEvent = PublishSubject<Bool>()

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let loginTriggered = input.loginTrigger

        return Output(fetching: fetching,
                      error: errors,
                      loginTriggered: loginTriggered)
    }
}
