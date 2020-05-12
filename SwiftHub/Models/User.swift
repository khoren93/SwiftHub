//
//  User.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper
import KeychainAccess
import MessageKit

private let userKey = "CurrentUserKey"
private let keychain = Keychain(service: Configs.App.bundleIdentifier)

enum UserType: String {
    case user = "User"
    case organization = "Organization"
}

struct ContributionCalendar {
    var totalContributions: Int?
    var months: [Month]?
    var weeks: [[ContributionDay]]?

    init(graph: ViewerQuery.Data.Viewer.ContributionsCollection?) {
        let calendar = graph?.contributionCalendar
        totalContributions = calendar?.totalContributions
        months = calendar?.months.map { Month(name: $0.name) }
        weeks = calendar?.weeks.map { $0.contributionDays.map { ContributionDay(color: $0.color, contributionCount: $0.contributionCount) } }
    }

    init(graph: UserQuery.Data.User.ContributionsCollection?) {
        let calendar = graph?.contributionCalendar
        totalContributions = calendar?.totalContributions
        months = calendar?.months.map { Month(name: $0.name) }
        weeks = calendar?.weeks.map { $0.contributionDays.map { ContributionDay(color: $0.color, contributionCount: $0.contributionCount) } }
    }

    struct Month {
        var name: String?
    }

    struct ContributionDay {
        var color: String?
        var contributionCount: Int?
    }
}

/// User model
struct User: Mappable, SenderType {

    var avatarUrl: String?  // A URL pointing to the user's public avatar.
    var blog: String?  // A URL pointing to the user's public website/blog.
    var company: String?  // The user's public profile company.
    var contributions: Int?
    var createdAt: Date?  // Identifies the date and time when the object was created.
    var email: String?  // The user's publicly visible profile email.
    var followers: Int?  // Identifies the total count of followers.
    var following: Int? // Identifies the total count of following.
    var htmlUrl: String?  // The HTTP URL for this user
    var location: String?  // The user's public profile location.
    var login: String?  // The username used to login.
    var name: String?  // The user's public profile name.
    var type: UserType = .user
    var updatedAt: Date?  // Identifies the date and time when the object was last updated.
    var starredRepositoriesCount: Int?  // Identifies the total count of repositories the user has starred.
    var repositoriesCount: Int?  // Identifies the total count of repositories that the user owns.
    var issuesCount: Int?  // Identifies the total count of issues associated with this user
    var watchingCount: Int?  // Identifies the total count of repositories the given user is watching
    var viewerCanFollow: Bool?  // Whether or not the viewer is able to follow the user.
    var viewerIsFollowing: Bool?  // Whether or not this user is followed by the viewer.
    var isViewer: Bool?  // Whether or not this user is the viewing user.
    var pinnedRepositories: [Repository]?  // A list of repositories this user has pinned to their profile
    var organizations: [User]?  // A list of organizations the user belongs to.
    var contributionCalendar: ContributionCalendar? // A calendar of this user's contributions on GitHub.

    // Only for Organization type
    var descriptionField: String?

    // Only for User type
    var bio: String?  // The user's public profile bio.

    // SenderType
    var senderId: String { return login ?? "" }
    var displayName: String { return login ?? "" }

    init?(map: Map) {}
    init() {}

    init(login: String?, name: String?, avatarUrl: String?, followers: Int?, viewerCanFollow: Bool?, viewerIsFollowing: Bool?) {
        self.login = login
        self.name = name
        self.avatarUrl = avatarUrl
        self.followers = followers
        self.viewerCanFollow = viewerCanFollow
        self.viewerIsFollowing = viewerIsFollowing
    }

    init(user: TrendingUser) {
        self.init(login: user.username, name: user.name, avatarUrl: user.avatar, followers: nil, viewerCanFollow: nil, viewerIsFollowing: nil)
        switch user.type {
        case .user: self.type = .user
        case .organization: self.type = .organization
        }
    }

    mutating func mapping(map: Map) {
        avatarUrl <- map["avatar_url"]
        blog <- map["blog"]
        company <- map["company"]
        contributions <- map["contributions"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        descriptionField <- map["description"]
        email <- map["email"]
        followers <- map["followers"]
        following <- map["following"]
        htmlUrl <- map["html_url"]
        location <- map["location"]
        login <- map["login"]
        name <- map["name"]
        repositoriesCount <- map["public_repos"]
        type <- map["type"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        bio <- map["bio"]
    }
}

/// GraphQL initializators for User model
extension User {
    init(graph: ViewerQuery.Data.Viewer?) {
        self.init(login: graph?.login, name: graph?.name, avatarUrl: graph?.avatarUrl, followers: graph?.followers.totalCount,
                  viewerCanFollow: graph?.viewerCanFollow, viewerIsFollowing: graph?.viewerIsFollowing)
        htmlUrl = graph?.url
        blog = graph?.websiteUrl
        bio = graph?.bio
        company = graph?.company
        email = graph?.email
        location = graph?.location
        createdAt = graph?.createdAt.toISODate()?.date
        updatedAt = graph?.updatedAt.toISODate()?.date
        isViewer = graph?.isViewer
        following = graph?.following.totalCount
        starredRepositoriesCount = graph?.starredRepositories.totalCount
        repositoriesCount = graph?.repositories.totalCount
        issuesCount = graph?.issues.totalCount
        watchingCount = graph?.watching.totalCount
        pinnedRepositories = graph?.pinnedItems.nodes?.map { Repository(graph: $0?.asRepository) }
        organizations = graph?.organizations.nodes?.map { User(graph: $0) }
        contributionCalendar = ContributionCalendar(graph: graph?.contributionsCollection)
    }

    init(graph: UserQuery.Data.User?) {
        self.init(login: graph?.login, name: graph?.name, avatarUrl: graph?.avatarUrl, followers: graph?.followers.totalCount,
                  viewerCanFollow: graph?.viewerCanFollow, viewerIsFollowing: graph?.viewerIsFollowing)
        htmlUrl = graph?.url
        blog = graph?.websiteUrl
        bio = graph?.bio
        company = graph?.company
        email = graph?.email
        location = graph?.location
        createdAt = graph?.createdAt.toISODate()?.date
        updatedAt = graph?.updatedAt.toISODate()?.date
        isViewer = graph?.isViewer
        following = graph?.following.totalCount
        starredRepositoriesCount = graph?.starredRepositories.totalCount
        repositoriesCount = graph?.repositories.totalCount
        issuesCount = graph?.issues.totalCount
        watchingCount = graph?.watching.totalCount
        pinnedRepositories = graph?.pinnedItems.nodes?.map { Repository(graph: $0?.asRepository) }
        organizations = graph?.organizations.nodes?.map { User(graph: $0) }
        contributionCalendar = ContributionCalendar(graph: graph?.contributionsCollection)
    }

    init(graph: SearchUsersQuery.Data.Search.Node.AsUser?) {
        self.init(login: graph?.login, name: graph?.name, avatarUrl: graph?.avatarUrl, followers: graph?.followers.totalCount,
                  viewerCanFollow: graph?.viewerCanFollow, viewerIsFollowing: graph?.viewerIsFollowing)
        repositoriesCount = graph?.repositories.totalCount
    }

    init(graph: UserQuery.Data.User.Organization.Node?) {
        self.init(login: graph?.login, name: graph?.name, avatarUrl: graph?.avatarUrl,
                  followers: nil, viewerCanFollow: nil, viewerIsFollowing: nil)
        descriptionField = graph?.description
        type = UserType.organization
    }

    init(graph: ViewerQuery.Data.Viewer.Organization.Node?) {
        self.init(login: graph?.login, name: graph?.name, avatarUrl: graph?.avatarUrl,
                  followers: nil, viewerCanFollow: nil, viewerIsFollowing: nil)
        descriptionField = graph?.description
        type = UserType.organization
    }
}

extension User {
    func isMine() -> Bool {
        if let isViewer = isViewer {
            return isViewer
        }
        return self == User.currentUser()
    }

    func save() {
        if let json = self.toJSONString() {
            keychain[userKey] = json
        } else {
            logError("User can't be saved")
        }
    }

    static func currentUser() -> User? {
        if let json = keychain[userKey], let user = User(JSONString: json) {
            return user
        }
        return nil
    }

    static func removeCurrentUser() {
        keychain[userKey] = nil
    }
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.login == rhs.login
    }
}

/// UserSearch model
struct UserSearch: Mappable {

    var items: [User] = []
    var totalCount: Int = 0
    var incompleteResults: Bool = false
    var hasNextPage: Bool = false
    var endCursor: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
        hasNextPage = items.isNotEmpty
    }
}

/// GraphQL initializators for UserSearch model
extension UserSearch {
    init(graph: SearchUsersQuery.Data.Search) {
        if let users = graph.nodes?.map({ User(graph: $0?.asUser) }) {
            items = users
        }
        totalCount = graph.userCount
        hasNextPage = graph.pageInfo.hasNextPage
        endCursor = graph.pageInfo.endCursor
    }
}

enum TrendingUserType: String {
    case user
    case organization
}

/// TrendingUser model
struct TrendingUser: Mappable {

    var username: String?
    var name: String?
    var url: String?
    var avatar: String?
    var repo: TrendingRepository?
    var type: TrendingUserType = .user

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        username <- map["username"]
        name <- map["name"]
        url <- map["url"]
        avatar <- map["avatar"]
        repo <- map["repo"]
        type <- map["type"]
        repo?.author = username
    }
}

extension TrendingUser: Equatable {
    static func == (lhs: TrendingUser, rhs: TrendingUser) -> Bool {
        return lhs.username == rhs.username
    }
}
