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
    // MARK: - Authentication is optional

    case searchRepositories(query: String)
    case repository(fullName: String)
    case watchers(fullName: String, page: Int)
    case stargazers(fullName: String, page: Int)
    case forks(fullName: String, page: Int)
    case readme(fullName: String, ref: String?)
    case contents(fullName: String, path: String, ref: String?)

    case repositoryIssues(fullName: String, state: String, page: Int)
    case commits(fullName: String, page: Int)
    case commit(fullName: String, sha: String)
    case branches(fullName: String, page: Int)
    case branch(fullName: String, name: String)
    case pullRequests(fullName: String, state: String, page: Int)
    case pullRequest(fullName: String, number: Int)

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

    // MARK: - Authentication is required

    case profile

    case notifications(all: Bool, participating: Bool, page: Int)
    case repositoryNotifications(fullName: String, all: Bool, participating: Bool, page: Int)
}

extension GithubAPI: TargetType, ProductAPIType {

    var baseURL: URL {
        return Configs.Network.baseURL.url!
    }

    var path: String {
        switch self {
        case .searchRepositories: return "/search/repositories"
        case .repository(let fullName): return "/repos/\(fullName)"
        case .watchers(let fullName, _): return "/repos/\(fullName)/subscribers"
        case .stargazers(let fullName, _): return "/repos/\(fullName)/stargazers"
        case .forks(let fullName, _): return "/repos/\(fullName)/forks"
        case .readme(let fullName, _): return "/repos/\(fullName)/readme"
        case .contents(let fullName, let path, _): return "/repos/\(fullName)/contents/\(path)"
        case .repositoryIssues(let fullName, _, _): return "/repos/\(fullName)/issues"
        case .commits(let fullName, _): return "/repos/\(fullName)/commits"
        case .commit(let fullName, let sha): return "/repos/\(fullName)/commits/\(sha)"
        case .branches(let fullName, _): return "/repos/\(fullName)/branches"
        case .branch(let fullName, let name): return "/repos/\(fullName)/branches/\(name)"
        case .pullRequests(let fullName, _, _): return "/repos/\(fullName)/pulls"
        case .pullRequest(let fullName, let number): return "/repos/\(fullName)/pulls/\(number)"
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
        case .notifications: return "/notifications"
        case .repositoryNotifications(let fullName, _, _, _): return "/repos/\(fullName)/notifications"
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
        var params: [String: Any] = [:]
        switch self {
        case .searchRepositories(let query):
            params["q"] = query
        case .watchers(_, let page):
            params["page"] = page
        case .stargazers(_, let page):
            params["page"] = page
        case .forks(_, let page):
            params["page"] = page
        case .readme(_, let ref):
            params["ref"] = ref
        case .contents(_, _, let ref):
            params["ref"] = ref
        case .repositoryIssues(_, let state, let page):
            params["state"] = state
            params["page"] = page
        case .commits(_, let page):
            params["page"] = page
        case .branches(_, let page):
            params["page"] = page
        case .pullRequests(_, let state, let page):
            params["state"] = state
            params["page"] = page
        case .searchUsers(let query):
            params["q"] = query
        case .userRepositories(_, let page):
            params["page"] = page
        case .userStarredRepositories(_, let page):
            params["page"] = page
        case .userFollowers(_, let page):
            params["page"] = page
        case .userFollowing(_, let page):
            params["page"] = page
        case .events(let page):
            params["page"] = page
        case .repositoryEvents(_, _, let page):
            params["page"] = page
        case .userReceivedEvents(_, let page):
            params["page"] = page
        case .userPerformedEvents(_, let page):
            params["page"] = page
        case .notifications(let all, let participating, let page),
             .repositoryNotifications(_, let all, let participating, let page):
            params["all"] = all
            params["participating"] = participating
            params["page"] = page
        default: break
        }
        return params
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
        case .readme: return stubbedResponse("RepositoryReadme")
        case .contents: return stubbedResponse("RepositoryContents")
        case .repositoryIssues: return stubbedResponse("RepositoryIssues")
        case .commits: return stubbedResponse("RepositoryCommits")
        case .commit: return stubbedResponse("RepositoryCommit")
        case .branches: return stubbedResponse("RepositoryBranches")
        case .branch: return stubbedResponse("RepositoryBranch")
        case .pullRequests: return stubbedResponse("RepositoryPullRequests")
        case .pullRequest: return stubbedResponse("RepositoryPullRequest")
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
        case .notifications: return stubbedResponse("Notifications")
        case .repositoryNotifications: return stubbedResponse("NotificationsRepository")
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
