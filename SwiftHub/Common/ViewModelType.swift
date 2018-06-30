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

    deinit {
        logDebug("\(type(of: self)) view model deinit")
    }
}
