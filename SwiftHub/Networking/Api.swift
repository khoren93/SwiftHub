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
import ObjectMapper
import Moya_ObjectMapper

enum ApiError: Error {
    case serverError(title: String, description: String)
}

protocol SwiftHubAPI {
    // MARK: - Authentication is optional
    func searchRepositories(query: String) -> Observable<RepositorySearch>
    func repository(fullName: String) -> Observable<Repository>
    func watchers(fullName: String, page: Int) -> Observable<[User]>
    func stargazers(fullName: String, page: Int) -> Observable<[User]>
    func forks(fullName: String, page: Int) -> Observable<[Repository]>
    func readme(fullName: String, ref: String?) -> Observable<Content>
    func contents(fullName: String, path: String, ref: String?) -> Observable<[Content]>
    func repositoryIssues(fullName: String, state: String, page: Int) -> Observable<[Issue]>
    func commits(fullName: String, page: Int) -> Observable<[Commit]>
    func commit(fullName: String, sha: String) -> Observable<Commit>
    func branches(fullName: String, page: Int) -> Observable<[Branch]>
    func branch(fullName: String, name: String) -> Observable<Branch>
    func pullRequests(fullName: String, state: String, page: Int) -> Observable<[PullRequest]>
    func pullRequest(fullName: String, number: Int) -> Observable<PullRequest>
    func contributors(fullName: String, page: Int) -> Observable<[User]>
    func searchUsers(query: String) -> Observable<UserSearch>
    func user(owner: String) -> Observable<User>
    func organization(owner: String) -> Observable<User>
    func userRepositories(username: String, page: Int) -> Observable<[Repository]>
    func userStarredRepositories(username: String, page: Int) -> Observable<[Repository]>
    func userFollowers(username: String, page: Int) -> Observable<[User]>
    func userFollowing(username: String, page: Int) -> Observable<[User]>
    func events(page: Int) -> Observable<[Event]>
    func repositoryEvents(owner: String, repo: String, page: Int) -> Observable<[Event]>
    func userReceivedEvents(username: String, page: Int) -> Observable<[Event]>
    func userPerformedEvents(username: String, page: Int) -> Observable<[Event]>

    // MARK: - Authentication is required
    func profile() -> Observable<User>
    func notifications(all: Bool, participating: Bool, page: Int) -> Observable<[Notification]>
    func repositoryNotifications(fullName: String, all: Bool, participating: Bool, page: Int) -> Observable<[Notification]>
}

class Api: SwiftHubAPI {
    static let shared = Api()
    var provider = Configs.Network.useStaging ? Networking.newStubbingNetworking() : Networking.newDefaultNetworking()
}

extension Api {
    // MARK: - Authentication is optional

    func searchRepositories(query: String) -> Observable<RepositorySearch> {
        return requestObject(.searchRepositories(query: query), type: RepositorySearch.self)
    }

    func watchers(fullName: String, page: Int) -> Observable<[User]> {
        return requestArray(.watchers(fullName: fullName, page: page), type: User.self)
    }

    func stargazers(fullName: String, page: Int) -> Observable<[User]> {
        return requestArray(.stargazers(fullName: fullName, page: page), type: User.self)
    }

    func forks(fullName: String, page: Int) -> Observable<[Repository]> {
        return requestArray(.forks(fullName: fullName, page: page), type: Repository.self)
    }

    func readme(fullName: String, ref: String?) -> Observable<Content> {
        return requestObject(.readme(fullName: fullName, ref: ref), type: Content.self)
    }

    func contents(fullName: String, path: String, ref: String?) -> Observable<[Content]> {
        return requestArray(.contents(fullName: fullName, path: path, ref: ref), type: Content.self)
    }

    func repositoryIssues(fullName: String, state: String, page: Int) -> Observable<[Issue]> {
        return requestArray(.repositoryIssues(fullName: fullName, state: state, page: page), type: Issue.self)
    }

    func commits(fullName: String, page: Int) -> Observable<[Commit]> {
        return requestArray(.commits(fullName: fullName, page: page), type: Commit.self)
    }

    func commit(fullName: String, sha: String) -> Observable<Commit> {
        return requestObject(.commit(fullName: fullName, sha: sha), type: Commit.self)
    }

    func branches(fullName: String, page: Int) -> Observable<[Branch]> {
        return requestArray(.branches(fullName: fullName, page: page), type: Branch.self)
    }

    func branch(fullName: String, name: String) -> Observable<Branch> {
        return requestObject(.branch(fullName: fullName, name: name), type: Branch.self)
    }

    func pullRequests(fullName: String, state: String, page: Int) -> Observable<[PullRequest]> {
        return requestArray(.pullRequests(fullName: fullName, state: state, page: page), type: PullRequest.self)
    }

    func pullRequest(fullName: String, number: Int) -> Observable<PullRequest> {
        return requestObject(.pullRequest(fullName: fullName, number: number), type: PullRequest.self)
    }

    func contributors(fullName: String, page: Int) -> Observable<[User]> {
        return requestArray(.contributors(fullName: fullName, page: page), type: User.self)
    }

    func repository(fullName: String) -> Observable<Repository> {
        return requestObject(.repository(fullName: fullName), type: Repository.self)
    }

    func searchUsers(query: String) -> Observable<UserSearch> {
        return requestObject(.searchUsers(query: query), type: UserSearch.self)
    }

    func user(owner: String) -> Observable<User> {
        return requestObject(.user(owner: owner), type: User.self)
    }

    func organization(owner: String) -> Observable<User> {
        return requestObject(.organization(owner: owner), type: User.self)
    }

    func userRepositories(username: String, page: Int) -> Observable<[Repository]> {
        return requestArray(.userRepositories(username: username, page: page), type: Repository.self)
    }

    func userStarredRepositories(username: String, page: Int) -> Observable<[Repository]> {
        return requestArray(.userStarredRepositories(username: username, page: page), type: Repository.self)
    }

    func userFollowers(username: String, page: Int) -> Observable<[User]> {
        return requestArray(.userFollowers(username: username, page: page), type: User.self)
    }

    func userFollowing(username: String, page: Int) -> Observable<[User]> {
        return requestArray(.userFollowing(username: username, page: page), type: User.self)
    }

    func events(page: Int) -> Observable<[Event]> {
        return requestArray(.events(page: page), type: Event.self)
    }

    func repositoryEvents(owner: String, repo: String, page: Int) -> Observable<[Event]> {
        return requestArray(.repositoryEvents(owner: owner, repo: repo, page: page), type: Event.self)
    }

    func userReceivedEvents(username: String, page: Int) -> Observable<[Event]> {
        return requestArray(.userReceivedEvents(username: username, page: page), type: Event.self)
    }

    func userPerformedEvents(username: String, page: Int) -> Observable<[Event]> {
        return requestArray(.userPerformedEvents(username: username, page: page), type: Event.self)
    }

    // MARK: - Authentication is required

    func profile() -> Observable<User> {
        return requestObject(.profile, type: User.self)
    }

    func notifications(all: Bool, participating: Bool, page: Int) -> Observable<[Notification]> {
        return requestArray(.notifications(all: all, participating: participating, page: page), type: Notification.self)
    }

    func repositoryNotifications(fullName: String, all: Bool, participating: Bool, page: Int) -> Observable<[Notification]> {
        return requestArray(.repositoryNotifications(fullName: fullName, all: all, participating: participating, page: page), type: Notification.self)
    }
}

extension Api {
    private func requestObject<T: BaseMappable>(_ target: GithubAPI, type: T.Type) -> Observable<T> {
        return provider.request(target)
            .mapObject(T.self)
            .observeOn(MainScheduler.instance)
    }

    private func requestArray<T: BaseMappable>(_ target: GithubAPI, type: T.Type) -> Observable<[T]> {
        return provider.request(target)
            .mapArray(T.self)
            .observeOn(MainScheduler.instance)
    }
}
