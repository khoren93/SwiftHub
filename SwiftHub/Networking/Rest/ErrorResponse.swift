//
//  ErrorResponse.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 1/28/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation

struct ErrorResponse: Decodable {
    var message: String?
    var errors: [ErrorModel] = []
    var documentationUrl: String?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        message = map["message"]
        errors = map["errors"] ?? errors
        documentationUrl = map["documentation_url"]
    }

    func detail() -> String {
        return errors.map { $0.message ?? "" }
            .joined(separator: "\n")
    }
}

struct ErrorModel: Decodable {
    var code: String?
    var message: String?
    var field: String?
    var resource: String?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        code = map["code"]
        message = map["message"]
        field = map["field"]
        resource = map["resource"]
    }
}
