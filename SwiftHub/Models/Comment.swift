//
//  Comment.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 11/22/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import MessageKit

struct Comment: Decodable, MessageType {

    var authorAssociation: String?
    var body: String?
    var createdAt: Date?
    var htmlUrl: String?
    var id: Int?
    var issueUrl: String?
    var nodeId: String?
    var updatedAt: Date?
    var url: String?
    var user: User?

    // MessageType
    var sender: SenderType { return user ?? User() }
    var messageId: String { return id?.string ?? "" }
    var sentDate: Date { return createdAt ?? Date() }
    var kind: MessageKind { return .text(body ?? "") }

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        authorAssociation = map["author_association"]
        body = map["body"]
        createdAt = map["created_at"]
        htmlUrl = map["html_url"]
        id = map["id"]
        issueUrl = map["issue_url"]
        nodeId = map["node_id"]
        updatedAt = map["updated_at"]
        url = map["url"]
        user = map["user"]
    }
}
