//
//	Repository.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

// MARK: - Repository
public struct Repository: Glossy {

    public let archiveUrl: String!
    public let assigneesUrl: String!
    public let blobsUrl: String!
    public let branchesUrl: String!
    public let cloneUrl: String!
    public let collaboratorsUrl: String!
    public let commentsUrl: String!
    public let commitsUrl: String!
    public let compareUrl: String!
    public let contentsUrl: String!
    public let contributorsUrl: String!
    public let createdAt: String!
    public let defaultBranch: String!
    public let deploymentsUrl: String!
    public let descriptionField: String!
    public let downloadsUrl: String!
    public let eventsUrl: String!
    public let fork: Bool!
    public let forks: Int!
    public let forksCount: Int!
    public let forksUrl: String!
    public let fullName: String!
    public let gitCommitsUrl: String!
    public let gitRefsUrl: String!
    public let gitTagsUrl: String!
    public let gitUrl: String!
    public let hasDownloads: Bool!
    public let hasIssues: Bool!
    public let hasPages: Bool!
    public let hasProjects: Bool!
    public let hasWiki: Bool!
    public let homepage: String!
    public let hooksUrl: String!
    public let htmlUrl: String!
    public let id: Int!
    public let issueCommentUrl: String!
    public let issueEventsUrl: String!
    public let issuesUrl: String!
    public let keysUrl: String!
    public let labelsUrl: String!
    public let language: String!
    public let languagesUrl: String!
    public let mergesUrl: String!
    public let milestonesUrl: String!
    public let mirrorUrl: AnyObject!
    public let name: String!
    public let notificationsUrl: String!
    public let openIssues: Int!
    public let openIssuesCount: Int!
    public let owner: Organization!
    public let privateField: Bool!
    public let pullsUrl: String!
    public let pushedAt: String!
    public let releasesUrl: String!
    public let size: Int!
    public let sshUrl: String!
    public let stargazersCount: Int!
    public let stargazersUrl: String!
    public let statusesUrl: String!
    public let subscribersUrl: String!
    public let subscriptionUrl: String!
    public let svnUrl: String!
    public let tagsUrl: String!
    public let teamsUrl: String!
    public let treesUrl: String!
    public let updatedAt: String!
    public let url: String!
    public let watchers: Int!
    public let watchersCount: Int!

    // MARK: Decodable
    public init?(json: JSON) {
        archiveUrl = "archive_url" <~~ json
        assigneesUrl = "assignees_url" <~~ json
        blobsUrl = "blobs_url" <~~ json
        branchesUrl = "branches_url" <~~ json
        cloneUrl = "clone_url" <~~ json
        collaboratorsUrl = "collaborators_url" <~~ json
        commentsUrl = "comments_url" <~~ json
        commitsUrl = "commits_url" <~~ json
        compareUrl = "compare_url" <~~ json
        contentsUrl = "contents_url" <~~ json
        contributorsUrl = "contributors_url" <~~ json
        createdAt = "created_at" <~~ json
        defaultBranch = "default_branch" <~~ json
        deploymentsUrl = "deployments_url" <~~ json
        descriptionField = "description" <~~ json
        downloadsUrl = "downloads_url" <~~ json
        eventsUrl = "events_url" <~~ json
        fork = "fork" <~~ json
        forks = "forks" <~~ json
        forksCount = "forks_count" <~~ json
        forksUrl = "forks_url" <~~ json
        fullName = "full_name" <~~ json
        gitCommitsUrl = "git_commits_url" <~~ json
        gitRefsUrl = "git_refs_url" <~~ json
        gitTagsUrl = "git_tags_url" <~~ json
        gitUrl = "git_url" <~~ json
        hasDownloads = "has_downloads" <~~ json
        hasIssues = "has_issues" <~~ json
        hasPages = "has_pages" <~~ json
        hasProjects = "has_projects" <~~ json
        hasWiki = "has_wiki" <~~ json
        homepage = "homepage" <~~ json
        hooksUrl = "hooks_url" <~~ json
        htmlUrl = "html_url" <~~ json
        id = "id" <~~ json
        issueCommentUrl = "issue_comment_url" <~~ json
        issueEventsUrl = "issue_events_url" <~~ json
        issuesUrl = "issues_url" <~~ json
        keysUrl = "keys_url" <~~ json
        labelsUrl = "labels_url" <~~ json
        language = "language" <~~ json
        languagesUrl = "languages_url" <~~ json
        mergesUrl = "merges_url" <~~ json
        milestonesUrl = "milestones_url" <~~ json
        mirrorUrl = "mirror_url" <~~ json
        name = "name" <~~ json
        notificationsUrl = "notifications_url" <~~ json
        openIssues = "open_issues" <~~ json
        openIssuesCount = "open_issues_count" <~~ json
        owner = "owner" <~~ json
        privateField = "private" <~~ json
        pullsUrl = "pulls_url" <~~ json
        pushedAt = "pushed_at" <~~ json
        releasesUrl = "releases_url" <~~ json
        size = "size" <~~ json
        sshUrl = "ssh_url" <~~ json
        stargazersCount = "stargazers_count" <~~ json
        stargazersUrl = "stargazers_url" <~~ json
        statusesUrl = "statuses_url" <~~ json
        subscribersUrl = "subscribers_url" <~~ json
        subscriptionUrl = "subscription_url" <~~ json
        svnUrl = "svn_url" <~~ json
        tagsUrl = "tags_url" <~~ json
        teamsUrl = "teams_url" <~~ json
        treesUrl = "trees_url" <~~ json
        updatedAt = "updated_at" <~~ json
        url = "url" <~~ json
        watchers = "watchers" <~~ json
        watchersCount = "watchers_count" <~~ json
    }

    // MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "archive_url" ~~> archiveUrl,
            "assignees_url" ~~> assigneesUrl,
            "blobs_url" ~~> blobsUrl,
            "branches_url" ~~> branchesUrl,
            "clone_url" ~~> cloneUrl,
            "collaborators_url" ~~> collaboratorsUrl,
            "comments_url" ~~> commentsUrl,
            "commits_url" ~~> commitsUrl,
            "compare_url" ~~> compareUrl,
            "contents_url" ~~> contentsUrl,
            "contributors_url" ~~> contributorsUrl,
            "created_at" ~~> createdAt,
            "default_branch" ~~> defaultBranch,
            "deployments_url" ~~> deploymentsUrl,
            "description" ~~> descriptionField,
            "downloads_url" ~~> downloadsUrl,
            "events_url" ~~> eventsUrl,
            "fork" ~~> fork,
            "forks" ~~> forks,
            "forks_count" ~~> forksCount,
            "forks_url" ~~> forksUrl,
            "full_name" ~~> fullName,
            "git_commits_url" ~~> gitCommitsUrl,
            "git_refs_url" ~~> gitRefsUrl,
            "git_tags_url" ~~> gitTagsUrl,
            "git_url" ~~> gitUrl,
            "has_downloads" ~~> hasDownloads,
            "has_issues" ~~> hasIssues,
            "has_pages" ~~> hasPages,
            "has_projects" ~~> hasProjects,
            "has_wiki" ~~> hasWiki,
            "homepage" ~~> homepage,
            "hooks_url" ~~> hooksUrl,
            "html_url" ~~> htmlUrl,
            "id" ~~> id,
            "issue_comment_url" ~~> issueCommentUrl,
            "issue_events_url" ~~> issueEventsUrl,
            "issues_url" ~~> issuesUrl,
            "keys_url" ~~> keysUrl,
            "labels_url" ~~> labelsUrl,
            "language" ~~> language,
            "languages_url" ~~> languagesUrl,
            "merges_url" ~~> mergesUrl,
            "milestones_url" ~~> milestonesUrl,
            "mirror_url" ~~> mirrorUrl,
            "name" ~~> name,
            "notifications_url" ~~> notificationsUrl,
            "open_issues" ~~> openIssues,
            "open_issues_count" ~~> openIssuesCount,
            "owner" ~~> owner,
            "private" ~~> privateField,
            "pulls_url" ~~> pullsUrl,
            "pushed_at" ~~> pushedAt,
            "releases_url" ~~> releasesUrl,
            "size" ~~> size,
            "ssh_url" ~~> sshUrl,
            "stargazers_count" ~~> stargazersCount,
            "stargazers_url" ~~> stargazersUrl,
            "statuses_url" ~~> statusesUrl,
            "subscribers_url" ~~> subscribersUrl,
            "subscription_url" ~~> subscriptionUrl,
            "svn_url" ~~> svnUrl,
            "tags_url" ~~> tagsUrl,
            "teams_url" ~~> teamsUrl,
            "trees_url" ~~> treesUrl,
            "updated_at" ~~> updatedAt,
            "url" ~~> url,
            "watchers" ~~> watchers,
            "watchers_count" ~~> watchersCount
            ])
    }
}
