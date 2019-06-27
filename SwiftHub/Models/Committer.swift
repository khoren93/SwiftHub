//
//  Committer.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import ObjectMapper

struct Committer: Mappable {

    var name: String?
    var email: String?
    var date: Date?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        name <- map["name"]
        email <- map["email"]
        date <- (map["date"], ISO8601DateTransform())
    }
}
