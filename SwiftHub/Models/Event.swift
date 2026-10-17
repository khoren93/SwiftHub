//
//  Event.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

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
enum EventType: String, Codable {
    case fork = "ForkEvent"
    case commitComment = "CommitCommentEvent"
    case create = "CreateEvent"
    case delete = "DeleteEvent"
    case issueComment = "IssueCommentEvent"
    case issues = "IssuesEvent"
    case member = "MemberEvent"
    case organizationBlock = "OrgBlockEvent"
    case `public` = "PublicEvent"
    case pullRequest = "PullRequestEvent"
    case pullRequestReviewComment = "PullRequestReviewCommentEvent"
    case push = "PushEvent"
    case release = "ReleaseEvent"
    case star = "WatchEvent"
    case unknown = ""
}

/// Each event has a similar JSON schema, but a unique payload object that is determined by its event type.
struct Event: Decodable {

    var actor: User?
    var createdAt: Date?
    var id: String?
    var organization: User?
    var isPublic: Bool?
    var repository: Repository?
    var type: EventType = .unknown

    var payload: Payload?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        actor = map["actor"]
        createdAt = map["created_at"]
        id = map["id"]
        organization = map["org"]
        isPublic = map["public"]
        repository = map["repo"]
        type = map["type"] ?? type

        payload = Payload.decode(type: type, from: decoder)

        if let fullname = repository?.name {
            let parts = fullname.components(separatedBy: "/")
            repository?.name = parts.last
            repository?.owner = User()
            repository?.owner?.login = parts.first
            repository?.fullname = fullname
        }
    }
}

extension Event: Equatable {
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
}

class Payload: Decodable {

    init() {}

    required init(from decoder: Decoder) throws {}

    /// Payload subclass for the event type; payload fields are read from the event's "payload" object
    static func decode(type: EventType, from decoder: Decoder) -> Payload? {
        switch type {
        case .fork: return try? ForkPayload(from: decoder)
        case .create: return try? CreatePayload(from: decoder)
        case .delete: return try? DeletePayload(from: decoder)
        case .issueComment: return try? IssueCommentPayload(from: decoder)
        case .issues: return try? IssuesPayload(from: decoder)
        case .member: return try? MemberPayload(from: decoder)
        case .pullRequest: return try? PullRequestPayload(from: decoder)
        case .pullRequestReviewComment: return try? PullRequestReviewCommentPayload(from: decoder)
        case .push: return try? PushPayload(from: decoder)
        case .release: return try? ReleasePayload(from: decoder)
        case .star: return try? StarPayload(from: decoder)
        default: return Payload()
        }
    }
}

class ForkPayload: Payload {

    var repository: Repository?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        repository = map["payload.forkee"]
        try super.init(from: decoder)
    }
}

enum CreateEventType: String, Codable {
    case repository
    case branch
    case tag
}

class CreatePayload: Payload {

    var ref: String?
    var refType: CreateEventType = .repository
    var masterBranch: String?
    var description: String?
    var pusherType: String?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        ref = map["payload.ref"]
        refType = map["payload.ref_type"] ?? refType
        masterBranch = map["payload.master_branch"]
        description = map["payload.description"]
        pusherType = map["payload.pusher_type"]
        try super.init(from: decoder)
    }
}

enum DeleteEventType: String, Codable {
    case repository
    case branch
    case tag
}

class DeletePayload: Payload {

    var ref: String?
    var refType: DeleteEventType = .repository
    var pusherType: String?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        ref = map["payload.ref"]
        refType = map["payload.ref_type"] ?? refType
        pusherType = map["payload.pusher_type"]
        try super.init(from: decoder)
    }
}

class IssueCommentPayload: Payload {

    var action: String?
    var issue: Issue?
    var comment: Comment?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        action = map["payload.action"]
        issue = map["payload.issue"]
        comment = map["payload.comment"]
        try super.init(from: decoder)
    }
}

class IssuesPayload: Payload {

    var action: String?
    var issue: Issue?
    var repository: Repository?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        action = map["payload.action"]
        issue = map["payload.issue"]
        repository = map["payload.forkee"]
        try super.init(from: decoder)
    }
}

class MemberPayload: Payload {

    var action: String?
    var member: User?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        action = map["payload.action"]
        member = map["payload.member"]
        try super.init(from: decoder)
    }
}

class PullRequestPayload: Payload {

    var action: String?
    var number: Int?
    var pullRequest: PullRequest?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        action = map["payload.action"]
        number = map["payload.number"]
        pullRequest = map["payload.pull_request"]
        try super.init(from: decoder)
    }
}

class PullRequestReviewCommentPayload: Payload {

    var action: String?
    var comment: Comment?
    var pullRequest: PullRequest?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        action = map["payload.action"]
        comment = map["payload.comment"]
        pullRequest = map["payload.pull_request"]
        try super.init(from: decoder)
    }
}

class PushPayload: Payload {

    var ref: String?
    var size: Int?
    var commits: [Commit] = []

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        ref = map["payload.ref"]
        size = map["payload.size"]
        commits = map["payload.commits"] ?? commits
        try super.init(from: decoder)
    }
}

class ReleasePayload: Payload {

    var action: String?
    var release: Release?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        action = map["payload.action"]
        release = map["payload.release"]
        try super.init(from: decoder)
    }
}

class StarPayload: Payload {

    var action: String?

    required init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        action = map["payload.action"]
        try super.init(from: decoder)
    }
}
