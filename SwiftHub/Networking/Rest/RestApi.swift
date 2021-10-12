//
//  RestApi.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 3/9/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper
import Moya
import Moya_ObjectMapper
import Alamofire

typealias MoyaError = Moya.MoyaError

enum ApiError: Error {
    case serverError(response: ErrorResponse)

    var title: String {
        switch self {
        case .serverError(let response): return response.message ?? ""
        }
    }

    var description: String {
        switch self {
        case .serverError(let response): return response.detail()
        }
    }
}

class RestApi: SwiftHubAPI {

    let githubProvider: GithubNetworking
    let trendingGithubProvider: TrendingGithubNetworking
    let codetabsProvider: CodetabsNetworking

    init(githubProvider: GithubNetworking, trendingGithubProvider: TrendingGithubNetworking, codetabsProvider: CodetabsNetworking) {
        self.githubProvider = githubProvider
        self.trendingGithubProvider = trendingGithubProvider
        self.codetabsProvider = codetabsProvider
    }
}

extension RestApi {

    func downloadString(url: URL) -> Single<String> {
        return Single.create { single in
            DispatchQueue.global().async {
                do {
                    single(.success(try String.init(contentsOf: url)))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create { }
            }
        .observe(on: MainScheduler.instance)
    }

    func downloadFile(url: URL, fileName: String?) -> Single<Void> {
        return githubProvider.request(.download(url: url, fileName: fileName))
            .mapToVoid()
            .asSingle()
    }

    // MARK: - Authentication is optional

    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectUri: String?, state: String?) -> Single<Token> {
        return Single.create { single in
            var params: Parameters = [:]
            params["client_id"] = clientId
            params["client_secret"] = clientSecret
            params["code"] = code
            params["redirect_uri"] = redirectUri
            params["state"] = state
            AF.request("https://github.com/login/oauth/access_token",
                       method: .post,
                       parameters: params,
                       encoding: URLEncoding.default,
                       headers: ["Accept": "application/json"])
                .responseJSON(completionHandler: { (response) in
                    if let error = response.error {
                        single(.failure(error))
                        return
                    }
                    if let json = response.value as? [String: Any] {
                        if let token = Mapper<Token>().map(JSON: json) {
                            single(.success(token))
                            return
                        }
                    }
                    single(.failure(RxError.unknown))
                })
            return Disposables.create { }
            }
        .observe(on: MainScheduler.instance)
    }

    func searchRepositories(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<RepositorySearch> {
        return requestObject(.searchRepositories(query: query, sort: sort, order: order, page: page), type: RepositorySearch.self)
    }

    func watchers(fullname: String, page: Int) -> Single<[User]> {
        return requestArray(.watchers(fullname: fullname, page: page), type: User.self)
    }

    func stargazers(fullname: String, page: Int) -> Single<[User]> {
        return requestArray(.stargazers(fullname: fullname, page: page), type: User.self)
    }

    func forks(fullname: String, page: Int) -> Single<[Repository]> {
        return requestArray(.forks(fullname: fullname, page: page), type: Repository.self)
    }

    func readme(fullname: String, ref: String?) -> Single<Content> {
        return requestObject(.readme(fullname: fullname, ref: ref), type: Content.self)
    }

    func contents(fullname: String, path: String, ref: String?) -> Single<[Content]> {
        return requestArray(.contents(fullname: fullname, path: path, ref: ref), type: Content.self)
    }

    func issues(fullname: String, state: String, page: Int) -> Single<[Issue]> {
        return requestArray(.issues(fullname: fullname, state: state, page: page), type: Issue.self)
    }

    func issue(fullname: String, number: Int) -> Single<Issue> {
        return requestObject(.issue(fullname: fullname, number: number), type: Issue.self)
    }

    func issueComments(fullname: String, number: Int, page: Int) -> Single<[Comment]> {
        return requestArray(.issueComments(fullname: fullname, number: number, page: page), type: Comment.self)
    }

    func commits(fullname: String, page: Int) -> Single<[Commit]> {
        return requestArray(.commits(fullname: fullname, page: page), type: Commit.self)
    }

    func commit(fullname: String, sha: String) -> Single<Commit> {
        return requestObject(.commit(fullname: fullname, sha: sha), type: Commit.self)
    }

    func branches(fullname: String, page: Int) -> Single<[Branch]> {
        return requestArray(.branches(fullname: fullname, page: page), type: Branch.self)
    }

    func branch(fullname: String, name: String) -> Single<Branch> {
        return requestObject(.branch(fullname: fullname, name: name), type: Branch.self)
    }

    func releases(fullname: String, page: Int) -> Single<[Release]> {
        return requestArray(.releases(fullname: fullname, page: page), type: Release.self)
    }

    func release(fullname: String, releaseId: Int) -> Single<Release> {
        return requestObject(.release(fullname: fullname, releaseId: releaseId), type: Release.self)
    }

    func pullRequests(fullname: String, state: String, page: Int) -> Single<[PullRequest]> {
        return requestArray(.pullRequests(fullname: fullname, state: state, page: page), type: PullRequest.self)
    }

    func pullRequest(fullname: String, number: Int) -> Single<PullRequest> {
        return requestObject(.pullRequest(fullname: fullname, number: number), type: PullRequest.self)
    }

    func pullRequestComments(fullname: String, number: Int, page: Int) -> Single<[Comment]> {
        return requestArray(.pullRequestComments(fullname: fullname, number: number, page: page), type: Comment.self)
    }

    func contributors(fullname: String, page: Int) -> Single<[User]> {
        return requestArray(.contributors(fullname: fullname, page: page), type: User.self)
    }

    func repository(fullname: String, qualifiedName: String) -> Single<Repository> {
        return requestObject(.repository(fullname: fullname), type: Repository.self)
    }

    func searchUsers(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<UserSearch> {
        return requestObject(.searchUsers(query: query, sort: sort, order: order, page: page), type: UserSearch.self)
    }

    func user(owner: String) -> Single<User> {
        return requestObject(.user(owner: owner), type: User.self)
    }

    func organization(owner: String) -> Single<User> {
        return requestObject(.organization(owner: owner), type: User.self)
    }

    func userRepositories(username: String, page: Int) -> Single<[Repository]> {
        return requestArray(.userRepositories(username: username, page: page), type: Repository.self)
    }

    func userStarredRepositories(username: String, page: Int) -> Single<[Repository]> {
        return requestArray(.userStarredRepositories(username: username, page: page), type: Repository.self)
    }

    func userWatchingRepositories(username: String, page: Int) -> Single<[Repository]> {
        return requestArray(.userWatchingRepositories(username: username, page: page), type: Repository.self)
    }

    func userFollowers(username: String, page: Int) -> Single<[User]> {
        return requestArray(.userFollowers(username: username, page: page), type: User.self)
    }

    func userFollowing(username: String, page: Int) -> Single<[User]> {
        return requestArray(.userFollowing(username: username, page: page), type: User.self)
    }

    func events(page: Int) -> Single<[Event]> {
        return requestArray(.events(page: page), type: Event.self)
    }

    func repositoryEvents(owner: String, repo: String, page: Int) -> Single<[Event]> {
        return requestArray(.repositoryEvents(owner: owner, repo: repo, page: page), type: Event.self)
    }

    func userReceivedEvents(username: String, page: Int) -> Single<[Event]> {
        return requestArray(.userReceivedEvents(username: username, page: page), type: Event.self)
    }

    func userPerformedEvents(username: String, page: Int) -> Single<[Event]> {
        return requestArray(.userPerformedEvents(username: username, page: page), type: Event.self)
    }

    func organizationEvents(username: String, page: Int) -> Single<[Event]> {
        return requestArray(.organizationEvents(username: username, page: page), type: Event.self)
    }

    // MARK: - Authentication is required

    func profile() -> Single<User> {
        return requestObject(.profile, type: User.self)
    }

    func notifications(all: Bool, participating: Bool, page: Int) -> Single<[Notification]> {
        return requestArray(.notifications(all: all, participating: participating, page: page), type: Notification.self)
    }

    func repositoryNotifications(fullname: String, all: Bool, participating: Bool, page: Int) -> Single<[Notification]> {
        return requestArray(.repositoryNotifications(fullname: fullname, all: all, participating: participating, page: page), type: Notification.self)
    }

    func markAsReadNotifications() -> Single<Void> {
        return requestWithoutMapping(.markAsReadNotifications).map { _ in }
    }

    func markAsReadRepositoryNotifications(fullname: String) -> Single<Void> {
        return requestWithoutMapping(.markAsReadRepositoryNotifications(fullname: fullname)).map { _ in }
    }

    func checkStarring(fullname: String) -> Single<Void> {
        return requestWithoutMapping(.checkStarring(fullname: fullname)).map { _ in }
    }

    func starRepository(fullname: String) -> Single<Void> {
        return requestWithoutMapping(.starRepository(fullname: fullname)).map { _ in }
    }

    func unstarRepository(fullname: String) -> Single<Void> {
        return requestWithoutMapping(.unstarRepository(fullname: fullname)).map { _ in }
    }

    func checkFollowing(username: String) -> Single<Void> {
        return requestWithoutMapping(.checkFollowing(username: username)).map { _ in }
    }

    func followUser(username: String) -> Single<Void> {
        return requestWithoutMapping(.followUser(username: username)).map { _ in }
    }

    func unfollowUser(username: String) -> Single<Void> {
        return requestWithoutMapping(.unfollowUser(username: username)).map { _ in }
    }

    // MARK: - Trending
    func trendingRepositories(language: String, since: String) -> Single<[TrendingRepository]> {
        return trendingRequestArray(.trendingRepositories(language: language, since: since), type: TrendingRepository.self)
    }

    func trendingDevelopers(language: String, since: String) -> Single<[TrendingUser]> {
        return trendingRequestArray(.trendingDevelopers(language: language, since: since), type: TrendingUser.self)
    }

    func languages() -> Single<[Language]> {
        return trendingRequestArray(.languages, type: Language.self)
    }

    // MARK: Codetabs
    func numberOfLines(fullname: String) -> Single<[LanguageLines]> {
        return codetabsRequestArray(.numberOfLines(fullname: fullname), type: LanguageLines.self)
    }
}

extension RestApi {
    private func request(_ target: GithubAPI) -> Single<Any> {
        return githubProvider.request(target)
            .mapJSON()
            .observe(on: MainScheduler.instance)
            .asSingle()
    }

    private func requestWithoutMapping(_ target: GithubAPI) -> Single<Moya.Response> {
        return githubProvider.request(target)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }

    private func requestObject<T: BaseMappable>(_ target: GithubAPI, type: T.Type) -> Single<T> {
        return githubProvider.request(target)
            .mapObject(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }

    private func requestArray<T: BaseMappable>(_ target: GithubAPI, type: T.Type) -> Single<[T]> {
        return githubProvider.request(target)
            .mapArray(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
}

extension RestApi {
    private func trendingRequestObject<T: BaseMappable>(_ target: TrendingGithubAPI, type: T.Type) -> Single<T> {
        return trendingGithubProvider.request(target)
            .mapObject(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }

    private func trendingRequestArray<T: BaseMappable>(_ target: TrendingGithubAPI, type: T.Type) -> Single<[T]> {
        return trendingGithubProvider.request(target)
            .mapArray(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
}

extension RestApi {
    private func codetabsRequestArray<T: BaseMappable>(_ target: CodetabsApi, type: T.Type) -> Single<[T]> {
        return codetabsProvider.request(target)
            .mapArray(T.self)
            .observe(on: MainScheduler.instance)
            .asSingle()
    }
}
