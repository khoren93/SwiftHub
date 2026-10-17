//
//  Committer.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation

struct Committer: Decodable {

    var name: String?
    var email: String?
    var date: Date?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        name = map["name"]
        email = map["email"]
        date = map["date"]
    }
}
