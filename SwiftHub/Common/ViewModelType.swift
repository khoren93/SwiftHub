//
//  ViewModelType.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {

    let provider: SwiftHubAPI

    var page = 1

    let loading = ActivityIndicator()
    let headerLoading = ActivityIndicator()
    let footerLoading = ActivityIndicator()

    let error = ErrorTracker()
    let serverError = PublishSubject<Error>()
    let parsedError = PublishSubject<ApiError>()

    init(provider: SwiftHubAPI) {
        self.provider = provider
        super.init()

        serverError.asObservable().map { (error) -> ApiError? in
            guard let response = (error as? MoyaError)?.response,
                  let errorResponse = try? response.map(ErrorResponse.self, using: JSONDecoder.swiftHub) else { return nil }
            return ApiError.serverError(response: errorResponse)
        }.filterNil().bind(to: parsedError).disposed(by: rx.disposeBag)

        parsedError.subscribe(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }

    deinit {
        logDebug("\(type(of: self)): Deinited")
        logResourcesCount()
    }
}
