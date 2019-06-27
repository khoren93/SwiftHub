//
//  PullRequest.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct PullRequest: Mappable {

    var activeLockReason: String?
    var additions: Int?
    var assignee: User?
    var assignees: [User]?
    var authorAssociation: String?
//    var base: Base?
    var body: String?
    var changedFiles: Int?
    var closedAt: Date?
    var comments: Int?
    var commentsUrl: String?
    var commits: Int?
    var commitsUrl: String?
    var createdAt: Date?
    var deletions: Int?
    var diffUrl: String?
//    var head: Base?
    var htmlUrl: String?
    var id: Int?
    var issueUrl: String?
    var labels: [IssueLabel]?
    var locked: Bool?
    var maintainerCanModify: Bool?
    var mergeCommitSha: String?
    var mergeable: Bool?
    var mergeableState: String?
    var merged: Bool?
    var mergedAt: Date?
    var mergedBy: User?
    var milestone: Milestone?
    var nodeId: String?
    var number: Int?
    var patchUrl: String?
    var rebaseable: Bool?
    var requestedReviewers: [User]?
//    var requestedTeams: [RequestedTeam]?
    var reviewCommentUrl: String?
    var reviewComments: Int?
    var reviewCommentsUrl: String?
    var state: State = .open
    var statusesUrl: String?
    var title: String?
    var updatedAt: Date?
    var url: String?
    var user: User?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        activeLockReason <- map["active_lock_reason"]
        additions <- map["additions"]
        assignee <- map["assignee"]
        assignees <- map["assignees"]
        authorAssociation <- map["author_association"]
//        base <- map["base"]
        body <- map["body"]
        changedFiles <- map["changed_files"]
        closedAt <- (map["closed_at"], ISO8601DateTransform())
        comments <- map["comments"]
        commentsUrl <- map["comments_url"]
        commits <- map["commits"]
        commitsUrl <- map["commits_url"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        deletions <- map["deletions"]
        diffUrl <- map["diff_url"]
//        head <- map["head"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        issueUrl <- map["issue_url"]
        labels <- map["labels"]
        locked <- map["locked"]
        maintainerCanModify <- map["maintainer_can_modify"]
        mergeCommitSha <- map["merge_commit_sha"]
        mergeable <- map["mergeable"]
        mergeableState <- map["mergeable_state"]
        merged <- map["merged"]
        mergedAt <- (map["merged_at"], ISO8601DateTransform())
        mergedBy <- map["merged_by"]
        milestone <- map["milestone"]
        nodeId <- map["node_id"]
        number <- map["number"]
        patchUrl <- map["patch_url"]
        rebaseable <- map["rebaseable"]
        requestedReviewers <- map["requested_reviewers"]
//        requestedTeams <- map["requested_teams"]
        reviewCommentUrl <- map["review_comment_url"]
        reviewComments <- map["review_comments"]
        reviewCommentsUrl <- map["review_comments_url"]
        state <- map["state"]
        statusesUrl <- map["statuses_url"]
        title <- map["title"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
        user <- map["user"]
    }
}
