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

private let userKey = "CurrentUserKey"
private let keychain = Keychain(service: Configs.App.bundleIdentifier)

enum UserType: String {
    case user = "User"
    case organization = "Organization"
}

struct User: Mappable {

    // Common
    var avatarUrl: String?
    var blog: String?
    var company: String?
    var contributions: Int?
    var createdAt: Date?
    var email: String?
    var followers: Int?
    var following: Int?
    var htmlUrl: String?
    var id: Int?
    var location: String?
    var login: String?
    var name: String?
    var nodeId: String?
    var publicGists: Int?
    var publicRepos: Int?
    var type: UserType = .user
    var updatedAt: Date?
    var score: Float?

    // Only for Organization type
    var descriptionField: String?
    var hasOrganizationProjects: Bool?
    var hasRepositoryProjects: Bool?

    // Only for User type
    var bio: String?
    var gravatarId: String?
    var hireable: Bool?
    var siteAdmin: Bool?

    var viewerCanFollow: Bool?
    var viewerIsFollowing: Bool?

    init?(map: Map) {}
    init() {}

    init(user: TrendingUser) {
        login = user.username
        name = user.name
        htmlUrl = user.url
        avatarUrl = user.avatar
    }

    init(graph: SearchUsersQuery.Data.Search.Node.AsUser?) {
        guard let graph = graph else { return }
        name = graph.name
        login = graph.login
        avatarUrl = graph.avatarUrl
        location = graph.location
        email = graph.email
        followers = graph.followers.totalCount
        viewerCanFollow = graph.viewerCanFollow
        viewerIsFollowing = graph.viewerIsFollowing
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
        hasOrganizationProjects <- map["has_organization_projects"]
        hasRepositoryProjects <- map["has_repository_projects"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        location <- map["location"]
        login <- map["login"]
        name <- map["name"]
        nodeId <- map["node_id"]
        publicGists <- map["public_gists"]
        publicRepos <- map["public_repos"]
        type <- map["type"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        score <- map["score"]
        bio <- map["bio"]
        gravatarId <- map["gravatar_id"]
        hireable <- map["hireable"]
        siteAdmin <- map["site_admin"]
    }
}

extension User {

    func isMine() -> Bool {
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
        return lhs.id == rhs.id
    }
}

struct UserSearch: Mappable {

    var items: [User] = []
    var totalCount: Int = 0
    var incompleteResults: Bool = false
    var hasNextPage: Bool = true
    var endCursor: String?

    init?(map: Map) {}
    init() {}

    init(graph: SearchUsersQuery.Data.Search) {
        if let users = graph.nodes?.map({ User(graph: $0?.asUser) }) {
            items = users
        }
        totalCount = graph.userCount
        hasNextPage = graph.pageInfo.hasNextPage
        endCursor = graph.pageInfo.endCursor
    }

    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
    }
}

struct TrendingUser: Mappable {

    var username: String?
    var name: String?
    var url: String?
    var avatar: String?
    var repo: TrendingRepository?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        username <- map["username"]
        name <- map["name"]
        url <- map["url"]
        avatar <- map["avatar"]
        repo <- map["repo"]
        repo?.author = username
    }
}

extension TrendingUser: Equatable {
    static func == (lhs: TrendingUser, rhs: TrendingUser) -> Bool {
        return lhs.username == rhs.username
    }
}
