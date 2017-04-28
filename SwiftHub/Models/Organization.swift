//
//	Organization.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

//	The "Swift - Struct - Gloss" support has been made available by CodeEagle
//	More about him/her can be found at his/her website: https://github.com/CodeEagle

import Foundation
import Gloss

// MARK: - Organization
public struct Organization: Glossy {

    public let avatarUrl: String!
    public let eventsUrl: String!
    public let followersUrl: String!
    public let followingUrl: String!
    public let gistsUrl: String!
    public let gravatarId: String!
    public let htmlUrl: String!
    public let id: Int!
    public let login: String!
    public let organizationsUrl: String!
    public let receivedEventsUrl: String!
    public let reposUrl: String!
    public let siteAdmin: Bool!
    public let starredUrl: String!
    public let subscriptionsUrl: String!
    public let type: String!
    public let url: String!

    // MARK: Decodable
    public init?(json: JSON) {
        avatarUrl = "avatar_url" <~~ json
        eventsUrl = "events_url" <~~ json
        followersUrl = "followers_url" <~~ json
        followingUrl = "following_url" <~~ json
        gistsUrl = "gists_url" <~~ json
        gravatarId = "gravatar_id" <~~ json
        htmlUrl = "html_url" <~~ json
        id = "id" <~~ json
        login = "login" <~~ json
        organizationsUrl = "organizations_url" <~~ json
        receivedEventsUrl = "received_events_url" <~~ json
        reposUrl = "repos_url" <~~ json
        siteAdmin = "site_admin" <~~ json
        starredUrl = "starred_url" <~~ json
        subscriptionsUrl = "subscriptions_url" <~~ json
        type = "type" <~~ json
        url = "url" <~~ json
    }

    // MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "avatar_url" ~~> avatarUrl,
            "events_url" ~~> eventsUrl,
            "followers_url" ~~> followersUrl,
            "following_url" ~~> followingUrl,
            "gists_url" ~~> gistsUrl,
            "gravatar_id" ~~> gravatarId,
            "html_url" ~~> htmlUrl,
            "id" ~~> id,
            "login" ~~> login,
            "organizations_url" ~~> organizationsUrl,
            "received_events_url" ~~> receivedEventsUrl,
            "repos_url" ~~> reposUrl,
            "site_admin" ~~> siteAdmin,
            "starred_url" ~~> starredUrl,
            "subscriptions_url" ~~> subscriptionsUrl,
            "type" ~~> type,
            "url" ~~> url
            ])
    }
}
