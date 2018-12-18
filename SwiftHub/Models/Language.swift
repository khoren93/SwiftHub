//
//  Language.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/17/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import ObjectMapper

struct Languages: Mappable {

    var popular: [Language]?
    var all: [Language]?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        popular <- map["popular"]
        all <- map["all"]
    }
}

struct Language: Mappable {

    var urlParam: String?
    var name: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        urlParam <- map["urlParam"]
        name <- map["name"]
    }
}

extension Language: Equatable {
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.urlParam == rhs.urlParam
    }
}
