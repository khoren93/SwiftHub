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
import SafariServices

private let loginURL = URL(string: "http://github.com/login/oauth/authorize?client_id=\(Keys.github.appId)&scope=user+repo+notifications")!
private let callbackURLScheme = "swifthub"

class LoginViewModel: ViewModel, ViewModelType {

    struct Input {
        let segmentSelection: Driver<LoginSegments>
        let basicLoginTrigger: Driver<Void>
        let oAuthLoginTrigger: Driver<Void>
    }

    struct Output {
        let fetching: Driver<Bool>
        let error: Driver<Error>
        let basicLoginTriggered: Driver<Void>
        let oAuthLoginTriggered: Driver<Void>
        let basicLoginButtonEnabled: Driver<Bool>
        let hidesBasicLoginView: Driver<Bool>
        let hidesOAuthLoginView: Driver<Bool>
    }

    let login = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")

    let loginEvent = PublishSubject<Bool>()

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()

        let fetching = activityIndicator.asDriver()
        let errors = errorTracker.asDriver()

        let basicLoginTriggered = input.basicLoginTrigger
        let oAuthLoginTriggered = input.oAuthLoginTrigger

        basicLoginTriggered.drive(onNext: { [weak self] () in
            if let login = self?.login.value,
                let password = self?.password.value,
                let authHash = "\(login):\(password)".base64Encoded {
                AuthManager.shared.token = Token(basicToken: "Basic \(authHash)")
            }
        }).disposed(by: rx.disposeBag)

        oAuthLoginTriggered.drive(onNext: { () in
            logDebug("oAuth login coming soon.")
        }).disposed(by: rx.disposeBag)

        let inputs = BehaviorRelay.combineLatest(login, password)

        let basicLoginButtonEnabled = BehaviorRelay.combineLatest(inputs, activityIndicator.asObservable()) {
            return $0.0.isNotEmpty && $0.1.isNotEmpty && !$1
        }.asDriver(onErrorJustReturn: false)

        let hidesBasicLoginView = input.segmentSelection.map { $0 != LoginSegments.basic }
        let hidesOAuthLoginView = input.segmentSelection.map { $0 != LoginSegments.oAuth }

        return Output(fetching: fetching,
                      error: errors,
                      basicLoginTriggered: basicLoginTriggered,
                      oAuthLoginTriggered: oAuthLoginTriggered,
                      basicLoginButtonEnabled: basicLoginButtonEnabled,
                      hidesBasicLoginView: hidesBasicLoginView,
                      hidesOAuthLoginView: hidesOAuthLoginView)
    }
}
