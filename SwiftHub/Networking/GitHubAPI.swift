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

let gitHubProvider = MoyaProvider<GithubAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])

enum GithubAPI {
    case searchRepositories(query: String)
    case searchUsers(query: String)
    case userRepositories(username: String)
    case userStarredRepositories(username: String)
    case repository(owner: String, repo: String)
    case user(owner: String)
    case organization(owner: String)
    case userFollowers(username: String)
    case userFollowing(username: String)
}

extension GithubAPI: TargetType, ProductAPIType {

    var baseURL: URL {
        return Configs.Network.baseURL.url!
    }

    var path: String {
        switch self {
        case .searchRepositories: return "/search/repositories"
        case .searchUsers: return "/search/users"
        case .userRepositories(let username): return "/users/\(username)/repos"
        case .userStarredRepositories(let username): return "/users/\(username)/starred"
        case .repository(let owner, let repo): return "/repos/\(owner)/\(repo)"
        case .user(let owner): return "/users/\(owner)"
        case .organization(let owner): return "/orgs/\(owner)"
        case .userFollowers(let username): return "/users/\(username)/followers"
        case .userFollowing(let username): return "/users/\(username)/following"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any]? {
        switch self {
        case .searchRepositories(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            return params
        case .searchUsers(let query):
            var params: [String: Any] = [:]
            params["q"] = query
            return params
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
        case .searchUsers: return stubbedResponse("UserSearch")
        case .userRepositories: return stubbedResponse("UserRepositories")
        case .userStarredRepositories: return stubbedResponse("UserRepositoriesStarred")
        case .repository: return stubbedResponse("Repository")
        case .user: return stubbedResponse("User")
        case .organization: return stubbedResponse("Organization")
        case .userFollowers: return stubbedResponse("UserFollowers")
        case .userFollowing: return stubbedResponse("UserFollowing")
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
        default: return false
        }
    }
}
