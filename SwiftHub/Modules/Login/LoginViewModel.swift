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
import RxSwiftExt
import SafariServices

private let loginURL = URL(string: "http://github.com/login/oauth/authorize?client_id=\(Keys.github.appId)&scope=\(Configs.App.githubScope)")!
private let callbackURLScheme = "swifthub"

class LoginViewModel: ViewModel, ViewModelType {

    struct Input {
        let segmentSelection: Driver<LoginSegments>
        let basicLoginTrigger: Driver<Void>
        let personalLoginTrigger: Driver<Void>
        let oAuthLoginTrigger: Driver<Void>
    }

    struct Output {
        let basicLoginButtonEnabled: Driver<Bool>
        let personalLoginButtonEnabled: Driver<Bool>
        let hidesBasicLoginView: Driver<Bool>
        let hidesPersonalLoginView: Driver<Bool>
        let hidesOAuthLoginView: Driver<Bool>
    }

    let login = BehaviorRelay(value: "")
    let password = BehaviorRelay(value: "")

    let personalToken = BehaviorRelay(value: "")

    let code = PublishSubject<String>()

    var tokenSaved = PublishSubject<Void>()

    private var _authSession: Any?

    private var authSession: SFAuthenticationSession? {
        get {
            return _authSession as? SFAuthenticationSession
        }
        set {
            _authSession = newValue
        }
    }

    func transform(input: Input) -> Output {

        input.basicLoginTrigger.drive(onNext: { [weak self] () in
            if let login = self?.login.value,
                let password = self?.password.value,
                let authHash = "\(login):\(password)".base64Encoded {
                AuthManager.setToken(token: Token(basicToken: authHash))
                self?.tokenSaved.onNext(())
            }
        }).disposed(by: rx.disposeBag)

        input.personalLoginTrigger.drive(onNext: { [weak self] () in
            if let personalToken = self?.personalToken.value {
                AuthManager.setToken(token: Token(personalToken: personalToken))
                self?.tokenSaved.onNext(())
            }
        }).disposed(by: rx.disposeBag)

        input.oAuthLoginTrigger.drive(onNext: { [weak self] () in
            self?.authSession = SFAuthenticationSession(url: loginURL, callbackURLScheme: callbackURLScheme, completionHandler: { (callbackUrl, error) in
                if let error = error {
                    logError(error.localizedDescription)
                }
                if let codeValue = callbackUrl?.queryParameters?["code"] {
                    self?.code.onNext(codeValue)
                }
            })
            self?.authSession?.start()
        }).disposed(by: rx.disposeBag)

        let tokenRequest = code.flatMapLatest { (code) -> Observable<RxSwift.Event<Token>> in
            let clientId = Keys.github.appId
            let clientSecret = Keys.github.apiKey
            return self.provider.createAccessToken(clientId: clientId, clientSecret: clientSecret, code: code, redirectUri: nil, state: nil)
                .trackActivity(self.loading)
                .materialize()
        }.share()

        tokenRequest.elements().subscribe(onNext: { [weak self] (token) in
            AuthManager.setToken(token: token)
            self?.tokenSaved.onNext(())
        }).disposed(by: rx.disposeBag)

        tokenRequest.errors().bind(to: serverError).disposed(by: rx.disposeBag)

        let profileRequest = tokenSaved.flatMapLatest {
            return self.provider.profile()
                .trackActivity(self.loading)
                .materialize()
        }.share()

        profileRequest.elements().subscribe(onNext: { (user) in
            user.save()
            AuthManager.tokenValidated()
            if let login = user.login, let type = AuthManager.shared.token?.type().description {
                analytics.log(.login(login: login, type: type))
            }
            Application.shared.presentInitialScreen(in: Application.shared.window)
        }).disposed(by: rx.disposeBag)

        profileRequest.errors().bind(to: serverError).disposed(by: rx.disposeBag)
        serverError.subscribe(onNext: { (error) in
            AuthManager.removeToken()
        }).disposed(by: rx.disposeBag)

        let basicLoginButtonEnabled = BehaviorRelay.combineLatest(login, password, self.loading.asObservable()) {
            return $0.isNotEmpty && $1.isNotEmpty && !$2
        }.asDriver(onErrorJustReturn: false)

        let personalLoginButtonEnabled = BehaviorRelay.combineLatest(personalToken, self.loading.asObservable()) {
            return $0.isNotEmpty && !$1
        }.asDriver(onErrorJustReturn: false)

        let hidesBasicLoginView = input.segmentSelection.map { $0 != LoginSegments.basic }
        let hidesPersonalLoginView = input.segmentSelection.map { $0 != LoginSegments.personal }
        let hidesOAuthLoginView = input.segmentSelection.map { $0 != LoginSegments.oAuth }

        return Output(basicLoginButtonEnabled: basicLoginButtonEnabled,
                      personalLoginButtonEnabled: personalLoginButtonEnabled,
                      hidesBasicLoginView: hidesBasicLoginView,
                      hidesPersonalLoginView: hidesPersonalLoginView,
                      hidesOAuthLoginView: hidesOAuthLoginView)
    }
}
