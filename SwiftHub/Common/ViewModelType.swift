//
//  ViewModelType.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}

class ViewModel: NSObject {

    let provider: SwiftHubAPI

    var page = 0

    init(provider: SwiftHubAPI) {
        self.provider = provider
    }

    deinit {
        logDebug("\(type(of: self)): Deinited")
    }
}
