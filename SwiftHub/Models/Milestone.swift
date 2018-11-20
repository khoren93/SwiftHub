//
//  Milestone.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct Milestone: Mappable {

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

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        closedAt <- (map["closed_at"], ISO8601DateTransform())
        closedIssues <- map["closed_issues"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        creator <- map["creator"]
        descriptionField <- map["description"]
        dueOn <- (map["due_on"], ISO8601DateTransform())
        htmlUrl <- map["html_url"]
        id <- map["id"]
        labelsUrl <- map["labels_url"]
        nodeId <- map["node_id"]
        number <- map["number"]
        openIssues <- map["open_issues"]
        state <- map["state"]
        title <- map["title"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
    }
}
