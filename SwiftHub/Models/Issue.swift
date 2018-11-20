//
//  Issue.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct Issue: Mappable {

    var activeLockReason: String?
    var assignee: User?
    var assignees: [User]?
    var body: String?
    var closedAt: Date?
    var closedBy: User?
    var comments: Int?
    var commentsUrl: String?
    var createdAt: Date?
    var eventsUrl: String?
    var htmlUrl: String?
    var id: Int?
    var labels: [IssueLabel]?
    var labelsUrl: String?
    var locked: Bool?
    var milestone: Milestone?
    var nodeId: String?
    var number: Int?
    var pullRequest: PullRequest?
    var repositoryUrl: String?
    var state: State = .open
    var title: String?
    var updatedAt: Date?
    var url: String?
    var user: User?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        activeLockReason <- map["active_lock_reason"]
        assignee <- map["assignee"]
        assignees <- map["assignees"]
        body <- map["body"]
        closedAt <- (map["closed_at"], ISO8601DateTransform())
        closedBy <- map["closed_by"]
        comments <- map["comments"]
        commentsUrl <- map["comments_url"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        eventsUrl <- map["events_url"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        labels <- map["labels"]
        labelsUrl <- map["labels_url"]
        locked <- map["locked"]
        milestone <- map["milestone"]
        nodeId <- map["node_id"]
        number <- map["number"]
        pullRequest <- map["pull_request"]
        repositoryUrl <- map["repository_url"]
        state <- map["state"]
        title <- map["title"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
        user <- map["user"]
    }
}

struct IssueLabel: Mappable {

    var color: String?
    var defaultField: Bool?
    var descriptionField: String?
    var id: Int?
    var name: String?
    var nodeId: String?
    var url: String?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        color <- map["color"]
        defaultField <- map["default"]
        descriptionField <- map["description"]
        id <- map["id"]
        name <- map["name"]
        nodeId <- map["node_id"]
        url <- map["url"]
    }
}
