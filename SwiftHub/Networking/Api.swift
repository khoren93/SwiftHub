//
//  Api.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum ApiError: Error {
    case serverError(title: String, description: String)
}

protocol SwiftHubAPI {

}

class Api: SwiftHubAPI {
    static let shared = Api()
    //var provider = Configs.Network.useStaging ? Networking.newStubbingNetworking() : Networking.newDefaultNetworking()
}

// MARK: repositories requests
extension Api {

}
