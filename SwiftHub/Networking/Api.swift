//
//  Api.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SwiftHubAPI {
    func downloadString(url: URL) -> Single<String>
    func downloadFile(url: URL, fileName: String?) -> Single<Void>

    // MARK: - Authentication is optional
    func createAccessToken(clientId: String, clientSecret: String, code: String, redirectUri: String?, state: String?) -> Single<Token>
    func searchRepositories(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<RepositorySearch>
    func repository(fullname: String, qualifiedName: String) -> Single<Repository>
    func watchers(fullname: String, page: Int) -> Single<[User]>
    func stargazers(fullname: String, page: Int) -> Single<[User]>
    func forks(fullname: String, page: Int) -> Single<[Repository]>
    func readme(fullname: String, ref: String?) -> Single<Content>
    func contents(fullname: String, path: String, ref: String?) -> Single<[Content]>
    func issues(fullname: String, state: String, page: Int) -> Single<[Issue]>
    func issue(fullname: String, number: Int) -> Single<Issue>
    func issueComments(fullname: String, number: Int, page: Int) -> Single<[Comment]>
    func commits(fullname: String, page: Int) -> Single<[Commit]>
    func commit(fullname: String, sha: String) -> Single<Commit>
    func branches(fullname: String, page: Int) -> Single<[Branch]>
    func branch(fullname: String, name: String) -> Single<Branch>
    func releases(fullname: String, page: Int) -> Single<[Release]>
    func release(fullname: String, releaseId: Int) -> Single<Release>
    func pullRequests(fullname: String, state: String, page: Int) -> Single<[PullRequest]>
    func pullRequest(fullname: String, number: Int) -> Single<PullRequest>
    func pullRequestComments(fullname: String, number: Int, page: Int) -> Single<[Comment]>
    func contributors(fullname: String, page: Int) -> Single<[User]>
    func searchUsers(query: String, sort: String, order: String, page: Int, endCursor: String?) -> Single<UserSearch>
    func user(owner: String) -> Single<User>
    func organization(owner: String) -> Single<User>
    func userRepositories(username: String, page: Int) -> Single<[Repository]>
    func userStarredRepositories(username: String, page: Int) -> Single<[Repository]>
    func userWatchingRepositories(username: String, page: Int) -> Single<[Repository]>
    func userFollowers(username: String, page: Int) -> Single<[User]>
    func userFollowing(username: String, page: Int) -> Single<[User]>
    func events(page: Int) -> Single<[Event]>
    func repositoryEvents(owner: String, repo: String, page: Int) -> Single<[Event]>
    func userReceivedEvents(username: String, page: Int) -> Single<[Event]>
    func userPerformedEvents(username: String, page: Int) -> Single<[Event]>
    func organizationEvents(username: String, page: Int) -> Single<[Event]>

    // MARK: - Authentication is required
    func profile() -> Single<User>
    func notifications(all: Bool, participating: Bool, page: Int) -> Single<[Notification]>
    func repositoryNotifications(fullname: String, all: Bool, participating: Bool, page: Int) -> Single<[Notification]>
    func markAsReadNotifications() -> Single<Void>
    func markAsReadRepositoryNotifications(fullname: String) -> Single<Void>
    func checkStarring(fullname: String) -> Single<Void>
    func starRepository(fullname: String) -> Single<Void>
    func unstarRepository(fullname: String) -> Single<Void>
    func checkFollowing(username: String) -> Single<Void>
    func followUser(username: String) -> Single<Void>
    func unfollowUser(username: String) -> Single<Void>

    // MARK: - Trending
    func trendingRepositories(language: String, since: String) -> Single<[TrendingRepository]>
    func trendingDevelopers(language: String, since: String) -> Single<[TrendingUser]>
    func languages() -> Single<[Language]>

    // MARK: - Codetabs
    func numberOfLines(fullname: String) -> Single<[LanguageLines]>
}
