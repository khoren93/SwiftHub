//
//  Repository.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct Repository: Mappable {

    var archiveUrl: String?
    var archived: Bool?
    var assigneesUrl: String?
    var blobsUrl: String?
    var branchesUrl: String?
    var cloneUrl: String?
    var collaboratorsUrl: String?
    var commentsUrl: String?
    var commitsUrl: String?
    var compareUrl: String?
    var contentsUrl: String?
    var contributorsUrl: String?
    var createdAt: Date?
    var defaultBranch: String?
    var deploymentsUrl: String?
    var descriptionField: String?
    var downloadsUrl: String?
    var eventsUrl: String?
    var fork: Bool?
    var forks: Int?
    var forksCount: Int?
    var forksUrl: String?
    var fullName: String?
    var gitCommitsUrl: String?
    var gitRefsUrl: String?
    var gitTagsUrl: String?
    var gitUrl: String?
    var hasDownloads: Bool?
    var hasIssues: Bool?
    var hasPages: Bool?
    var hasProjects: Bool?
    var hasWiki: Bool?
    var homepage: String?
    var hooksUrl: String?
    var htmlUrl: String?
    var id: Int?
    var issueCommentUrl: String?
    var issueEventsUrl: String?
    var issuesUrl: String?
    var keysUrl: String?
    var labelsUrl: String?
    var language: String?
    var languagesUrl: String?
    var license: License?
    var mergesUrl: String?
    var milestonesUrl: String?
    var mirrorUrl: AnyObject?
    var name: String?
    var networkCount: Int?
    var nodeId: String?
    var notificationsUrl: String?
    var openIssues: Int?
    var openIssuesCount: Int?
    var organization: User?
    var owner: User?
    var privateField: Bool?
    var pullsUrl: String?
    var pushedAt: String?
    var releasesUrl: String?
    var size: Int?
    var sshUrl: String?
    var stargazersCount: Int?
    var stargazersUrl: String?
    var statusesUrl: String?
    var subscribersCount: Int?
    var subscribersUrl: String?
    var subscriptionUrl: String?
    var svnUrl: String?
    var tagsUrl: String?
    var teamsUrl: String?
    var treesUrl: String?
    var updatedAt: String?
    var url: String?
    var watchers: Int?
    var watchersCount: Int?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        archiveUrl <- map["archive_url"]
        archived <- map["archived"]
        assigneesUrl <- map["assignees_url"]
        blobsUrl <- map["blobs_url"]
        branchesUrl <- map["branches_url"]
        cloneUrl <- map["clone_url"]
        collaboratorsUrl <- map["collaborators_url"]
        commentsUrl <- map["comments_url"]
        commitsUrl <- map["commits_url"]
        compareUrl <- map["compare_url"]
        contentsUrl <- map["contents_url"]
        contributorsUrl <- map["contributors_url"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        defaultBranch <- map["default_branch"]
        deploymentsUrl <- map["deployments_url"]
        descriptionField <- map["description"]
        downloadsUrl <- map["downloads_url"]
        eventsUrl <- map["events_url"]
        fork <- map["fork"]
        forks <- map["forks"]
        forksCount <- map["forks_count"]
        forksUrl <- map["forks_url"]
        fullName <- map["full_name"]
        gitCommitsUrl <- map["git_commits_url"]
        gitRefsUrl <- map["git_refs_url"]
        gitTagsUrl <- map["git_tags_url"]
        gitUrl <- map["git_url"]
        hasDownloads <- map["has_downloads"]
        hasIssues <- map["has_issues"]
        hasPages <- map["has_pages"]
        hasProjects <- map["has_projects"]
        hasWiki <- map["has_wiki"]
        homepage <- map["homepage"]
        hooksUrl <- map["hooks_url"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        issueCommentUrl <- map["issue_comment_url"]
        issueEventsUrl <- map["issue_events_url"]
        issuesUrl <- map["issues_url"]
        keysUrl <- map["keys_url"]
        labelsUrl <- map["labels_url"]
        language <- map["language"]
        languagesUrl <- map["languages_url"]
        license <- map["license"]
        mergesUrl <- map["merges_url"]
        milestonesUrl <- map["milestones_url"]
        mirrorUrl <- map["mirror_url"]
        name <- map["name"]
        networkCount <- map["network_count"]
        nodeId <- map["node_id"]
        notificationsUrl <- map["notifications_url"]
        openIssues <- map["open_issues"]
        openIssuesCount <- map["open_issues_count"]
        organization <- map["organization"]
        owner <- map["owner"]
        privateField <- map["private"]
        pullsUrl <- map["pulls_url"]
        pushedAt <- map["pushed_at"]
        releasesUrl <- map["releases_url"]
        size <- map["size"]
        sshUrl <- map["ssh_url"]
        stargazersCount <- map["stargazers_count"]
        stargazersUrl <- map["stargazers_url"]
        statusesUrl <- map["statuses_url"]
        subscribersCount <- map["subscribers_count"]
        subscribersUrl <- map["subscribers_url"]
        subscriptionUrl <- map["subscription_url"]
        svnUrl <- map["svn_url"]
        tagsUrl <- map["tags_url"]
        teamsUrl <- map["teams_url"]
        treesUrl <- map["trees_url"]
        updatedAt <- map["updated_at"]
        url <- map["url"]
        watchers <- map["watchers"]
        watchersCount <- map["watchers_count"]
    }
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

struct RepositorySearch: Mappable {

    var items: [Repository] = []
    var totalCount: Int = 0
    var incompleteResults: Bool = false

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
    }
}
