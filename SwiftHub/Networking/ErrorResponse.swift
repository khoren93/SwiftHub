//
//  ErrorResponse.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 1/28/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import ObjectMapper

struct ErrorResponse: Mappable {
    var message: String?
    var errors: [ErrorModel] = []
    var documentationUrl: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        message <- map["message"]
        errors <- map["errors"]
        documentationUrl <- map["documentation_url"]
    }

    func detail() -> String {
        return errors.map { $0.message ?? "" }
            .joined(separator: "\n")
    }
}

struct ErrorModel: Mappable {
    var code: String?
    var message: String?
    var field: String?
    var resource: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        code <- map["code"]
        message <- map["message"]
        field <- map["field"]
        resource <- map["resource"]
    }
}
