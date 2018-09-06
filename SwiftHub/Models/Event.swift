//
//  Event.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import ObjectMapper

/// Event Types
///
/// - fork: Triggered when a user forks a repository.
/// - commitComment: Triggered when a commit comment is created.
/// - create: Represents a created repository, branch, or tag.
/// - issueComment: Triggered when an issue comment is created, edited, or deleted.
/// - issues: Triggered when an issue is assigned, unassigned, labeled, unlabeled, opened, edited, milestoned, demilestoned, closed, or reopened.
/// - member: Triggered when a user accepts an invitation or is removed as a collaborator to a repository, or has their permissions changed.
/// - organizationBlock: Triggered when an organization blocks or unblocks a user.
/// - `public`: Triggered when a private repository is open sourced. Without a doubt: the best GitHub event.
/// - release: Triggered when a release is published.
/// - star: The WatchEvent is related to starring a repository, not watching.
enum EventType: String {
    case fork = "ForkEvent"
    case commitComment = "CommitCommentEvent"
    case create = "CreateEvent"
    case issueComment = "IssueCommentEvent"
    case issues = "IssuesEvent"
    case member = "MemberEvent"
    case organizationBlock = "OrgBlockEvent"
    case `public` = "PublicEvent"
    case release = "ReleaseEvent"
    case star = "WatchEvent"
    case unknown = ""
}

/// Each event has a similar JSON schema, but a unique payload object that is determined by its event type.
struct Event: Mappable {

    var actor: User?
    var createdAt: Date?
    var id: String?
    var organization: User?
    var isPublic: Bool?
    var repository: Repository?
    var type: EventType = .unknown

    var payload: Payload?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        actor <- map["actor"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        id <- map["id"]
        organization <- map["org"]
        isPublic <- map["public"]
        repository <- map["repo"]
        type <- map["type"]

        payload = Mapper<Payload>().map(JSON: map.JSON)

        if let fullName = repository?.name {
            let parts = fullName.components(separatedBy: "/")
            repository?.name = parts.last
            repository?.owner = User()
            repository?.owner?.login = parts.first
            repository?.fullName = fullName
        }
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

class Payload: StaticMappable {

    required init?(map: Map) {}
    init() {}

    func mapping(map: Map) {}

    static func objectForMapping(map: Map) -> BaseMappable? {
        var type: EventType = .unknown
        type <- map["type"]
        switch type {
        case .fork: return ForkPayload()
        case .create: return CreatePayload()
        case .star: return StarPayload()
        default: return Payload()
        }
    }
}

class ForkPayload: Payload {

    var repository: Repository?

    override func mapping(map: Map) {
        super.mapping(map: map)

        repository <- map["payload.forkee"]
    }
}

class CreatePayload: Payload {

    var ref: String?
    var refType: String?
    var masterBranch: String?
    var description: String?
    var pusherType: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        ref <- map["payload.ref"]
        refType <- map["payload.ref_type"]
        masterBranch <- map["payload.master_branch"]
        description <- map["payload.description"]
        pusherType <- map["payload.pusher_type"]
    }
}

class StarPayload: Payload {

    var action: String?

    override func mapping(map: Map) {
        super.mapping(map: map)

        action <- map["payload.action"]
    }
}
