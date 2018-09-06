//
//  Token.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import ObjectMapper

struct Token: Mappable {

    var basicToken: String?
    var isValid = false

    init?(map: Map) {}
    init() {}

    init(basicToken: String) {
        self.basicToken = basicToken
    }

    mutating func mapping(map: Map) {
        basicToken <- map["basic_token"]
        isValid <- map["valid"]
    }
}
