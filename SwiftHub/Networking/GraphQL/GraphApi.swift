//
//  GraphApi.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 3/9/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Apollo

class GraphApi: SwiftHubAPI {

    let restApi: RestApi
    let token: String

    private(set) lazy var client: ApolloClient = {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store, token: token)
        let url = URL(string: "https://api.github.com/graphql")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }()

    init(restApi: RestApi, token: String) {
        self.restApi = restApi
        self.token = token
    }
}

class NetworkInterceptorProvider: DefaultInterceptorProvider {
    let token: String
    init(client: URLSessionClient = URLSessionClient(), store: ApolloStore, token: String) {
        self.token = token
        super.init(client: client, shouldInvalidateClientOnDeinit: true, store: store)
    }

    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(TokenAddingInterceptor(token: token), at: 0)
        return interceptors
    }
}

class TokenAddingInterceptor: ApolloInterceptor {
    let token: String

    init(token: String) {
        self.token = token
    }

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void) {

        request.addHeader(name: "Authorization", value: "Bearer \(token)")

        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}

extension GraphApi {
    func downloadString(url: URL) -> Single<String> {
        return restApi.downloadString(url: url)
    }

    func downloadFile(url: URL, fileName: String?) -> Single<Void> {
        return restApi.downloadFile(url: url, fileName: fileName)
    }

    // MARK: - Authentication is optional

    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectUri: String?, state: String?) -> Single<Token> {
        return restApi.createAccessToken(clientId: clientId, clientSecret: clientSecret, code: code, redirectUri: redirectUri, state: state)
    }

    func searchRepositories(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<RepositorySearch> {
        let query = query + (sort.isNotEmpty ? " sort:\(sort)-\(order)": "")
        return client.rx.fetch(query: SearchRepositoriesQuery(query: query, before: endCursor))
            .map { RepositorySearch(graph: $0.search) }
    }

    func watchers(fullname: String, page: Int) -> Single<[User]> {
        return restApi.watchers(fullname: fullname, page: page)
    }

    func stargazers(fullname: String, page: Int) -> Single<[User]> {
        return restApi.stargazers(fullname: fullname, page: page)
    }

    func forks(fullname: String, page: Int) -> Single<[Repository]> {
        return restApi.forks(fullname: fullname, page: page)
    }

    func readme(fullname: String, ref: String?) -> Single<Content> {
        return restApi.readme(fullname: fullname, ref: ref)
    }

    func contents(fullname: String, path: String, ref: String?) -> Single<[Content]> {
        return restApi.contents(fullname: fullname, path: path, ref: ref)
    }

    func issues(fullname: String, state: String, page: Int) -> Single<[Issue]> {
        return restApi.issues(fullname: fullname, state: state, page: page)
    }

    func issue(fullname: String, number: Int) -> Single<Issue> {
        return restApi.issue(fullname: fullname, number: number)
    }

    func issueComments(fullname: String, number: Int, page: Int) -> Single<[Comment]> {
        return restApi.issueComments(fullname: fullname, number: number, page: page)
    }

    func commits(fullname: String, page: Int) -> Single<[Commit]> {
        return restApi.commits(fullname: fullname, page: page)
    }

    func commit(fullname: String, sha: String) -> Single<Commit> {
        return restApi.commit(fullname: fullname, sha: sha)
    }

    func branches(fullname: String, page: Int) -> Single<[Branch]> {
        return restApi.branches(fullname: fullname, page: page)
    }

    func branch(fullname: String, name: String) -> Single<Branch> {
        return restApi.branch(fullname: fullname, name: name)
    }

    func releases(fullname: String, page: Int) -> Single<[Release]> {
        return restApi.releases(fullname: fullname, page: page)
    }

    func release(fullname: String, releaseId: Int) -> Single<Release> {
        return restApi.release(fullname: fullname, releaseId: releaseId)
    }

    func pullRequests(fullname: String, state: String, page: Int) -> Single<[PullRequest]> {
        return restApi.pullRequests(fullname: fullname, state: state, page: page)
    }

    func pullRequest(fullname: String, number: Int) -> Single<PullRequest> {
        return restApi.pullRequest(fullname: fullname, number: number)
    }

    func pullRequestComments(fullname: String, number: Int, page: Int) -> Single<[Comment]> {
        return restApi.pullRequestComments(fullname: fullname, number: number, page: page)
    }

    func contributors(fullname: String, page: Int) -> Single<[User]> {
        return restApi.contributors(fullname: fullname, page: page)
    }

    func repository(fullname: String, qualifiedName: String) -> Single<Repository> {
        return client.rx.fetch(query: RepositoryQuery(owner: ownerName(from: fullname), name: repoName(from: fullname), qualifiedName: qualifiedName))
            .map { Repository(graph: $0.repository) }
    }

    func searchUsers(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<UserSearch> {
        let query = query + (sort.isNotEmpty ? " sort:\(sort)-\(order)": "")
        return client.rx.fetch(query: SearchUsersQuery(query: query, before: endCursor))
            .map { UserSearch(graph: $0.search) }
    }

    func user(owner: String) -> Single<User> {
        return client.rx.fetch(query: UserQuery(login: owner))
            .map { User(graph: $0.user) }
    }

    func organization(owner: String) -> Single<User> {
        return restApi.organization(owner: owner)
    }

    func userRepositories(username: String, page: Int) -> Single<[Repository]> {
        return restApi.userRepositories(username: username, page: page)
    }

    func userStarredRepositories(username: String, page: Int) -> Single<[Repository]> {
        return restApi.userStarredRepositories(username: username, page: page)
    }

    func userWatchingRepositories(username: String, page: Int) -> Single<[Repository]> {
        return restApi.userWatchingRepositories(username: username, page: page)
    }

    func userFollowers(username: String, page: Int) -> Single<[User]> {
        return restApi.userFollowers(username: username, page: page)
    }

    func userFollowing(username: String, page: Int) -> Single<[User]> {
        return restApi.userFollowing(username: username, page: page)
    }

    func events(page: Int) -> Single<[Event]> {
        return restApi.events(page: page)
    }

    func repositoryEvents(owner: String, repo: String, page: Int) -> Single<[Event]> {
        return restApi.repositoryEvents(owner: owner, repo: repo, page: page)
    }

    func userReceivedEvents(username: String, page: Int) -> Single<[Event]> {
        return restApi.userReceivedEvents(username: username, page: page)
    }

    func userPerformedEvents(username: String, page: Int) -> Single<[Event]> {
        return restApi.userPerformedEvents(username: username, page: page)
    }

    func organizationEvents(username: String, page: Int) -> Single<[Event]> {
        return restApi.organizationEvents(username: username, page: page)
    }

    // MARK: - Authentication is required

    func profile() -> Single<User> {
        return client.rx.fetch(query: ViewerQuery())
            .map { User(graph: $0.viewer) }
    }

    func notifications(all: Bool, participating: Bool, page: Int) -> Single<[Notification]> {
        return restApi.notifications(all: all, participating: participating, page: page)
    }

    func repositoryNotifications(fullname: String, all: Bool, participating: Bool, page: Int) -> Single<[Notification]> {
        return restApi.repositoryNotifications(fullname: fullname, all: all, participating: participating, page: page)
    }

    func markAsReadNotifications() -> Single<Void> {
        return restApi.markAsReadNotifications()
    }

    func markAsReadRepositoryNotifications(fullname: String) -> Single<Void> {
        return restApi.markAsReadRepositoryNotifications(fullname: fullname)
    }

    func checkStarring(fullname: String) -> Single<Void> {
        return restApi.checkStarring(fullname: fullname)
    }

    func starRepository(fullname: String) -> Single<Void> {
        return restApi.starRepository(fullname: fullname)
    }

    func unstarRepository(fullname: String) -> Single<Void> {
        return restApi.unstarRepository(fullname: fullname)
    }

    func checkFollowing(username: String) -> Single<Void> {
        return restApi.checkFollowing(username: username)
    }

    func followUser(username: String) -> Single<Void> {
        return restApi.followUser(username: username)
    }

    func unfollowUser(username: String) -> Single<Void> {
        return restApi.unfollowUser(username: username)
    }

    // MARK: - Trending
    func trendingRepositories(language: String, since: String) -> Single<[TrendingRepository]> {
        return restApi.trendingRepositories(language: language, since: since)
    }

    func trendingDevelopers(language: String, since: String) -> Single<[TrendingUser]> {
        return restApi.trendingDevelopers(language: language, since: since)
    }

    func languages() -> Single<[Language]> {
        return restApi.languages()
    }

    // MARK: - Codetabs
    func numberOfLines(fullname: String) -> Single<[LanguageLines]> {
        return restApi.numberOfLines(fullname: fullname)
    }
}

extension GraphApi {
    private func ownerName(from fullname: String) -> String {
        return fullname.components(separatedBy: "/").first ?? ""
    }

    private func repoName(from fullname: String) -> String {
        return fullname.components(separatedBy: "/").last ?? ""
    }
}
