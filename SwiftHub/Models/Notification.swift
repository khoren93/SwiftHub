//
//  Notification.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 9/19/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Notification: Decodable {

    var id: String?
    var lastReadAt: Date?
    var reason: String?
    var repository: Repository?
    var subject: Subject?
    var subscriptionUrl: String?
    var unread: Bool?
    var updatedAt: Date?
    var url: String?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        id = map["id"]
        lastReadAt = map["last_read_at"]
        reason = map["reason"]
        repository = map["repository"]
        subject = map["subject"]
        subscriptionUrl = map["subscription_url"]
        unread = map["unread"]
        updatedAt = map["updated_at"]
        url = map["url"]
    }
}

extension Notification: Equatable {
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Subject: Decodable {

    var latestCommentUrl: String?
    var title: String?
    var type: String?
    var url: String?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        latestCommentUrl = map["latest_comment_url"]
        title = map["title"]
        type = map["type"]
        url = map["url"]
    }
}
