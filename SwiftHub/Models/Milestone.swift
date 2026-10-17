//
//  Milestone.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Milestone: Decodable {

    var closedAt: Date?
    var closedIssues: Int?
    var createdAt: Date?
    var creator: User?
    var descriptionField: String?
    var dueOn: Date?
    var htmlUrl: String?
    var id: Int?
    var labelsUrl: String?
    var nodeId: String?
    var number: Int?
    var openIssues: Int?
    var state: State = .open
    var title: String?
    var updatedAt: Date?
    var url: String?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        closedAt = map["closed_at"]
        closedIssues = map["closed_issues"]
        createdAt = map["created_at"]
        creator = map["creator"]
        descriptionField = map["description"]
        dueOn = map["due_on"]
        htmlUrl = map["html_url"]
        id = map["id"]
        labelsUrl = map["labels_url"]
        nodeId = map["node_id"]
        number = map["number"]
        openIssues = map["open_issues"]
        state = map["state"] ?? state
        title = map["title"]
        updatedAt = map["updated_at"]
        url = map["url"]
    }
}
