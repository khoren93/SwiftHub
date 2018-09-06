//
//  GitHubAPI.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Alamofire

protocol ProductAPIType {
    var addXAuth: Bool { get }
}

enum GithubAPI {
    // MARK: - Unauthenticated requests

    case searchRepositories(query: String)
    case repository(fullName: String)
    case watchers(owner: String, repo: String, page: Int)
    case stargazers(owner: String, repo: String, page: Int)
    case forks(owner: String, repo: String, page: Int)

    case searchUsers(query: String)
    case user(owner: String)
    case organization(owner: String)
    case userRepositories(username: String, page: Int)
    case userStarredRepositories(username: String, page: Int)
    case userFollowers(username: String, page: Int)
    case userFollowing(username: String, page: Int)

    case events(page: Int)
    case repositoryEvents(owner: String, repo: String, page: Int)
    case userReceivedEvents(username: String, page: Int)
    case userPerformedEvents(username: String, page: Int)

    // MARK: - Authenticated requests

    case profile
}

extension GithubAPI: TargetType, ProductAPIType {

    var baseURL: URL {
        return Configs.Network.baseURL.url!
    }

    var path: String {
        switch self {
        case .searchRepositories: return "/search/repositories"
        case .repository(let fullName): return "/repos/\(fullName)"
        case .watchers(let owner, let repo, _): return "/repos/\(owner)/\(repo)/subscribers"
        case .stargazers(let owner, let repo, _): return "/repos/\(owner)/\(repo)/stargazers"
        case .forks(let owner, let repo, _): return "/repos/\(owner)/\(repo)/forks"
        case .searchUsers: return "/search/users"
        case .user(let owner): return "/users/\(owner)"
        case .organization(let owner): return "/orgs/\(owner)"
        case .userRepositories(let username, _): return "/users/\(username)/repos"
        case .userStarredRepositories(let username, _): return "/users/\(username)/starred"
        case .userFollowers(let username, _): return "/users/\(username)/followers"
        case .userFollowing(let username, _): return "/users/\(username)/following"
        case .events: return "/events"
        case .repositoryEvents(let owner, let repo, _): return "/repos/\(owner)/\(repo)/events"
        case .userReceivedEvents(let username, _): return "/users/\(username)/received_events"
        case .userPerformedEvents(let username, _): return "/users/\(username)/events"

        case .profile: return "/user"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var headers: [String: String]? {
        if addXAuth, let basicToken = AuthManager.shared.token?.basicToken {
            return ["Authorization": basicToken]
        }
        return nil
    }

    var parameters: [String: Any]? {
        switch self {
        case .searchRepositories(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            return params
        case .watchers(_, _, let page):
            return [
                "page": page
            ]
        case .stargazers(_, _, let page):
            return [
                "page": page
            ]
        case .forks(_, _, let page):
            return [
                "page": page
            ]
        case .searchUsers(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            return params
        case .userRepositories(_, let page):
            return [
                "page": page
            ]
        case .userStarredRepositories(_, let page):
            return [
                "page": page
            ]
        case .userFollowers(_, let page):
            return [
                "page": page
            ]
        case .userFollowing(_, let page):
            return [
                "page": page
            ]
        case .events(let page):
            return [
                "page": page
            ]
        case .repositoryEvents(_, _, let page):
            return [
                "page": page
            ]
        case .userReceivedEvents(_, let page):
            return [
                "page": page
            ]
        case .userPerformedEvents(_, let page):
            return [
                "page": page
            ]
        default:
            return nil
        }
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        switch self {
        case .searchRepositories: return stubbedResponse("RepositorySearch")
        case .repository: return stubbedResponse("Repository")
        case .watchers: return stubbedResponse("RepositoryWatchers")
        case .stargazers: return stubbedResponse("RepositoryStargers")
        case .forks: return stubbedResponse("RepositoryForks")
        case .searchUsers: return stubbedResponse("UserSearch")
        case .user: return stubbedResponse("User")
        case .organization: return stubbedResponse("Organization")
        case .userRepositories: return stubbedResponse("UserRepositories")
        case .userStarredRepositories: return stubbedResponse("UserRepositoriesStarred")
        case .userFollowers: return stubbedResponse("UserFollowers")
        case .userFollowing: return stubbedResponse("UserFollowing")
        case .events: return stubbedResponse("Events")
        case .repositoryEvents: return stubbedResponse("EventsRepository")
        case .userReceivedEvents: return stubbedResponse("EventsUserReceived")
        case .userPerformedEvents: return stubbedResponse("EventsUserPerformed")

        case .profile: return stubbedResponse("Profile")
        }
    }

    public var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
        return .requestPlain
    }

    var addXAuth: Bool {
        switch self {
        default: return true
        }
    }
}
