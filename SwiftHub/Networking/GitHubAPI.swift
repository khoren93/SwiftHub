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

private let assetDir: URL = {
    let directoryURLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return directoryURLs.first ?? URL(fileURLWithPath: NSTemporaryDirectory())
}()

enum GithubAPI {
    case download(url: URL, fileName: String?)

    // MARK: - Authentication is optional
    case searchRepositories(query: String, sort: String, order: String, page: Int)
    case repository(fullname: String)
    case watchers(fullname: String, page: Int)
    case stargazers(fullname: String, page: Int)
    case forks(fullname: String, page: Int)
    case readme(fullname: String, ref: String?)
    case contents(fullname: String, path: String, ref: String?)

    case repositoryIssues(fullname: String, state: String, page: Int)
    case commits(fullname: String, page: Int)
    case commit(fullname: String, sha: String)
    case branches(fullname: String, page: Int)
    case branch(fullname: String, name: String)
    case pullRequests(fullname: String, state: String, page: Int)
    case pullRequest(fullname: String, number: Int)
    case contributors(fullname: String, page: Int)

    case searchUsers(query: String, sort: String, order: String, page: Int)
    case user(owner: String)
    case organization(owner: String)
    case userRepositories(username: String, page: Int)
    case userStarredRepositories(username: String, page: Int)
    case userWatchingRepositories(username: String, page: Int)
    case userFollowers(username: String, page: Int)
    case userFollowing(username: String, page: Int)

    case events(page: Int)
    case repositoryEvents(owner: String, repo: String, page: Int)
    case userReceivedEvents(username: String, page: Int)
    case userPerformedEvents(username: String, page: Int)

    // MARK: - Authentication is required
    case profile

    case notifications(all: Bool, participating: Bool, page: Int)
    case repositoryNotifications(fullname: String, all: Bool, participating: Bool, page: Int)

    case checkStarring(fullname: String)
    case starRepository(fullname: String)
    case unstarRepository(fullname: String)

    case checkFollowing(username: String)
    case followUser(username: String)
    case unfollowUser(username: String)
}

extension GithubAPI: TargetType, ProductAPIType {

    var baseURL: URL {
        switch self {
        case .download(let url, _):
            return url
        default:
            return Configs.Network.githubBaseUrl.url!
        }
    }

    var path: String {
        switch self {
        case .download: return ""
        case .searchRepositories: return "/search/repositories"
        case .repository(let fullname): return "/repos/\(fullname)"
        case .watchers(let fullname, _): return "/repos/\(fullname)/subscribers"
        case .stargazers(let fullname, _): return "/repos/\(fullname)/stargazers"
        case .forks(let fullname, _): return "/repos/\(fullname)/forks"
        case .readme(let fullname, _): return "/repos/\(fullname)/readme"
        case .contents(let fullname, let path, _): return "/repos/\(fullname)/contents/\(path)"
        case .repositoryIssues(let fullname, _, _): return "/repos/\(fullname)/issues"
        case .commits(let fullname, _): return "/repos/\(fullname)/commits"
        case .commit(let fullname, let sha): return "/repos/\(fullname)/commits/\(sha)"
        case .branches(let fullname, _): return "/repos/\(fullname)/branches"
        case .branch(let fullname, let name): return "/repos/\(fullname)/branches/\(name)"
        case .pullRequests(let fullname, _, _): return "/repos/\(fullname)/pulls"
        case .pullRequest(let fullname, let number): return "/repos/\(fullname)/pulls/\(number)"
        case .contributors(let fullname, _): return "/repos/\(fullname)/contributors"
        case .searchUsers: return "/search/users"
        case .user(let owner): return "/users/\(owner)"
        case .organization(let owner): return "/orgs/\(owner)"
        case .userRepositories(let username, _): return "/users/\(username)/repos"
        case .userStarredRepositories(let username, _): return "/users/\(username)/starred"
        case .userWatchingRepositories(let username, _): return "/users/\(username)/subscriptions"
        case .userFollowers(let username, _): return "/users/\(username)/followers"
        case .userFollowing(let username, _): return "/users/\(username)/following"
        case .events: return "/events"
        case .repositoryEvents(let owner, let repo, _): return "/repos/\(owner)/\(repo)/events"
        case .userReceivedEvents(let username, _): return "/users/\(username)/received_events"
        case .userPerformedEvents(let username, _): return "/users/\(username)/events"

        case .profile: return "/user"
        case .notifications: return "/notifications"
        case .repositoryNotifications(let fullname, _, _, _): return "/repos/\(fullname)/notifications"
        case .checkStarring(let fullname),
             .starRepository(let fullname),
             .unstarRepository(let fullname): return "/user/starred/\(fullname)"
        case .checkFollowing(let username),
             .followUser(let username),
             .unfollowUser(let username): return "/user/following/\(username)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .starRepository, .followUser:
            return .put
        case .unstarRepository, .unfollowUser:
            return .delete
        default:
            return .get
        }
    }

    var headers: [String: String]? {
        if let token = AuthManager.shared.token {
            switch token.type() {
            case .basic(let token):
                return ["Authorization": "Basic \(token)"]
            case .oAuth(let token):
                return ["Authorization": "token \(token)"]
            case .unauthorized: break
            }
        }
        return nil
    }

    var parameters: [String: Any]? {
        var params: [String: Any] = [:]
        switch self {
        case .searchRepositories(let query, let sort, let order, let page):
            params["q"] = query
            params["sort"] = sort
            params["order"] = order
            params["page"] = page
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
        case .contributors(_, let page):
            params["page"] = page
        case .searchUsers(let query, let sort, let order, let page):
            params["q"] = query
            params["sort"] = sort
            params["order"] = order
            params["page"] = page
        case .userRepositories(_, let page):
            params["page"] = page
        case .userStarredRepositories(_, let page):
            params["page"] = page
        case .userWatchingRepositories(_, let page):
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

    var localLocation: URL {
        switch self {
        case .download(_, let fileName):
            if let fileName = fileName {
                return assetDir.appendingPathComponent(fileName)
            }
        default: break
        }
        return assetDir
    }

    var downloadDestination: DownloadDestination {
        return { _, _ in return (self.localLocation, .removePreviousFile) }
    }

    public var task: Task {
        switch self {
        case .download:
            return .downloadDestination(downloadDestination)
        default:
            if let parameters = parameters {
                return .requestParameters(parameters: parameters, encoding: parameterEncoding)
            }
            return .requestPlain
        }
    }

    var sampleData: Data {
        switch self {
        case .download: return Data()
        case .searchRepositories: return stubbedResponse("RepositorySearch")
        case .repository: return stubbedResponse("Repository")
        case .watchers: return stubbedResponse("RepositoryWatchers")
        case .stargazers: return stubbedResponse("RepositoryStargazers")
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
        case .contributors: return stubbedResponse("RepositoryContributors")
        case .searchUsers: return stubbedResponse("UserSearch")
        case .user: return stubbedResponse("User")
        case .organization: return stubbedResponse("Organization")
        case .userRepositories: return stubbedResponse("UserRepositories")
        case .userStarredRepositories: return stubbedResponse("UserRepositoriesStarred")
        case .userWatchingRepositories: return stubbedResponse("UserRepositoriesWatching")
        case .userFollowers: return stubbedResponse("UserFollowers")
        case .userFollowing: return stubbedResponse("UserFollowing")
        case .events: return stubbedResponse("Events")
        case .repositoryEvents: return stubbedResponse("EventsRepository")
        case .userReceivedEvents: return stubbedResponse("EventsUserReceived")
        case .userPerformedEvents: return stubbedResponse("EventsUserPerformed")
        case .profile: return stubbedResponse("Profile")
        case .notifications: return stubbedResponse("Notifications")
        case .repositoryNotifications: return stubbedResponse("NotificationsRepository")
        case .checkStarring: return stubbedResponse("EmptyObject")
        case .starRepository: return stubbedResponse("EmptyObject")
        case .unstarRepository: return stubbedResponse("EmptyObject")
        case .checkFollowing: return stubbedResponse("EmptyObject")
        case .followUser: return stubbedResponse("EmptyObject")
        case .unfollowUser: return stubbedResponse("EmptyObject")
        }
    }

    var addXAuth: Bool {
        switch self {
        default: return true
        }
    }
}
