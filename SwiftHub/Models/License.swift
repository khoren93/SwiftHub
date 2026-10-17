//
//  License.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct License: Decodable {

    var key: String?
    var name: String?
    var nodeId: String?
    var spdxId: String?
    var url: String?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        key = map["key"]
        name = map["name"]
        nodeId = map["node_id"]
        spdxId = map["spdx_id"]
        url = map["url"]
    }
}
