//
//  Comment.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 11/22/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct Comment: Mappable {

    var authorAssociation: String?
    var body: String?
    var createdAt: String?
    var htmlUrl: String?
    var id: Int?
    var issueUrl: String?
    var nodeId: String?
    var updatedAt: String?
    var url: String?
    var user: User?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        authorAssociation <- map["author_association"]
        body <- map["body"]
        createdAt <- map["created_at"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        issueUrl <- map["issue_url"]
        nodeId <- map["node_id"]
        updatedAt <- map["updated_at"]
        url <- map["url"]
        user <- map["user"]
    }
}
