//
//  Branch.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct Branch: Mappable {

//    var links: Link?
    var commit: Commit?
    var name: String?
    var protectedField: Bool?
    var protectionUrl: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
//        links <- map["_links"]
        commit <- map["commit"]
        name <- map["name"]
        protectedField <- map["protected"]
        protectionUrl <- map["protection_url"]
    }
}
