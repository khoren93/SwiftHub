//
//  License.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct License: Mappable {

    var key: String?
    var name: String?
    var nodeId: String?
    var spdxId: AnyObject?
    var url: AnyObject?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        key <- map["key"]
        name <- map["name"]
        nodeId <- map["node_id"]
        spdxId <- map["spdx_id"]
        url <- map["url"]
    }
}
