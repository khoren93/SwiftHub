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

struct User: Mappable {

    enum UserType: String {
        case user = "User"
        case organization = "Organization"
    }

    // Common
    var avatarUrl: String?
    var blog: String?
    var company: String?
    var createdAt: Date?
    var email: String?
    var eventsUrl: String?
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
    var reposUrl: String?
    var type = UserType.user
    var updatedAt: Date?
    var url: String?

    // Only for Organization type
    var descriptionField: String?
    var hasOrganizationProjects: Bool?
    var hasRepositoryProjects: Bool?
    var hooksUrl: String?
    var issuesUrl: String?
    var membersUrl: String?
    var publicMembersUrl: String?

    // Only for User type
    var bio: String?
    var followersUrl: String?
    var followingUrl: String?
    var gistsUrl: String?
    var gravatarId: String?
    var hireable: Bool?
    var organizationsUrl: String?
    var receivedEventsUrl: String?
    var siteAdmin: Bool?
    var starredUrl: String?
    var subscriptionsUrl: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        avatarUrl <- map["avatar_url"]
        blog <- map["blog"]
        company <- map["company"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        descriptionField <- map["description"]
        email <- map["email"]
        eventsUrl <- map["events_url"]
        followers <- map["followers"]
        following <- map["following"]
        hasOrganizationProjects <- map["has_organization_projects"]
        hasRepositoryProjects <- map["has_repository_projects"]
        hooksUrl <- map["hooks_url"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        issuesUrl <- map["issues_url"]
        location <- map["location"]
        login <- map["login"]
        membersUrl <- map["members_url"]
        name <- map["name"]
        nodeId <- map["node_id"]
        publicGists <- map["public_gists"]
        publicMembersUrl <- map["public_members_url"]
        publicRepos <- map["public_repos"]
        reposUrl <- map["repos_url"]
        type <- map["type"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
        bio <- map["bio"]
        followersUrl <- map["followers_url"]
        followingUrl <- map["following_url"]
        gistsUrl <- map["gists_url"]
        gravatarId <- map["gravatar_id"]
        hireable <- map["hireable"]
        organizationsUrl <- map["organizations_url"]
        receivedEventsUrl <- map["received_events_url"]
        siteAdmin <- map["site_admin"]
        starredUrl <- map["starred_url"]
        subscriptionsUrl <- map["subscriptions_url"]
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

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        incompleteResults <- map["incomplete_results"]
    }
}
