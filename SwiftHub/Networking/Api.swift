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
        return provider.request(.searchRepositories(query: query))
            .mapObject(RepositorySearch.self)
            .observeOn(MainScheduler.instance)
    }

    func watchers(fullName: String, page: Int) -> Observable<[User]> {
        return provider.request(.watchers(fullName: fullName, page: page))
            .mapArray(User.self)
            .observeOn(MainScheduler.instance)
    }

    func stargazers(fullName: String, page: Int) -> Observable<[User]> {
        return provider.request(.stargazers(fullName: fullName, page: page))
            .mapArray(User.self)
            .observeOn(MainScheduler.instance)
    }

    func forks(fullName: String, page: Int) -> Observable<[Repository]> {
        return provider.request(.forks(fullName: fullName, page: page))
            .mapArray(Repository.self)
            .observeOn(MainScheduler.instance)
    }

    func readme(fullName: String, ref: String?) -> Observable<Content> {
        return provider.request(.readme(fullName: fullName, ref: ref))
            .mapObject(Content.self)
            .observeOn(MainScheduler.instance)
    }

    func contents(fullName: String, path: String, ref: String?) -> Observable<[Content]> {
        return provider.request(.contents(fullName: fullName, path: path, ref: ref))
            .mapArray(Content.self)
            .observeOn(MainScheduler.instance)
    }

    func repositoryIssues(fullName: String, state: String, page: Int) -> Observable<[Issue]> {
        return provider.request(.repositoryIssues(fullName: fullName, state: state, page: page))
            .mapArray(Issue.self)
            .observeOn(MainScheduler.instance)
    }

    func commits(fullName: String, page: Int) -> Observable<[Commit]> {
        return provider.request(.commits(fullName: fullName, page: page))
            .mapArray(Commit.self)
            .observeOn(MainScheduler.instance)
    }

    func commit(fullName: String, sha: String) -> Observable<Commit> {
        return provider.request(.commit(fullName: fullName, sha: sha))
            .mapObject(Commit.self)
            .observeOn(MainScheduler.instance)
    }

    func branches(fullName: String, page: Int) -> Observable<[Branch]> {
        return provider.request(.branches(fullName: fullName, page: page))
            .mapArray(Branch.self)
            .observeOn(MainScheduler.instance)
    }

    func branch(fullName: String, name: String) -> Observable<Branch> {
        return provider.request(.branch(fullName: fullName, name: name))
            .mapObject(Branch.self)
            .observeOn(MainScheduler.instance)
    }

    func pullRequests(fullName: String, state: String, page: Int) -> Observable<[PullRequest]> {
        return provider.request(.pullRequests(fullName: fullName, state: state, page: page))
            .mapArray(PullRequest.self)
            .observeOn(MainScheduler.instance)
    }

    func pullRequest(fullName: String, number: Int) -> Observable<PullRequest> {
        return provider.request(.pullRequest(fullName: fullName, number: number))
            .mapObject(PullRequest.self)
            .observeOn(MainScheduler.instance)
    }

    func repository(fullName: String) -> Observable<Repository> {
        return provider.request(.repository(fullName: fullName))
            .mapObject(Repository.self)
            .observeOn(MainScheduler.instance)
    }

    func searchUsers(query: String) -> Observable<UserSearch> {
        return provider.request(.searchUsers(query: query))
            .mapObject(UserSearch.self)
            .observeOn(MainScheduler.instance)
    }

    func user(owner: String) -> Observable<User> {
        return provider.request(.user(owner: owner))
            .mapObject(User.self)
            .observeOn(MainScheduler.instance)
    }

    func organization(owner: String) -> Observable<User> {
        return provider.request(.organization(owner: owner))
            .mapObject(User.self)
            .observeOn(MainScheduler.instance)
    }

    func userRepositories(username: String, page: Int) -> Observable<[Repository]> {
        return provider.request(.userRepositories(username: username, page: page))
            .mapArray(Repository.self)
            .observeOn(MainScheduler.instance)
    }

    func userStarredRepositories(username: String, page: Int) -> Observable<[Repository]> {
        return provider.request(.userStarredRepositories(username: username, page: page))
            .mapArray(Repository.self)
            .observeOn(MainScheduler.instance)
    }

    func userFollowers(username: String, page: Int) -> Observable<[User]> {
        return provider.request(.userFollowers(username: username, page: page))
            .mapArray(User.self)
            .observeOn(MainScheduler.instance)
    }

    func userFollowing(username: String, page: Int) -> Observable<[User]> {
        return provider.request(.userFollowing(username: username, page: page))
            .mapArray(User.self)
            .observeOn(MainScheduler.instance)
    }

    func events(page: Int) -> Observable<[Event]> {
        return provider.request(.events(page: page))
            .mapArray(Event.self)
            .observeOn(MainScheduler.instance)
    }

    func repositoryEvents(owner: String, repo: String, page: Int) -> Observable<[Event]> {
        return provider.request(.repositoryEvents(owner: owner, repo: repo, page: page))
            .mapArray(Event.self)
            .observeOn(MainScheduler.instance)
    }

    func userReceivedEvents(username: String, page: Int) -> Observable<[Event]> {
        return provider.request(.userReceivedEvents(username: username, page: page))
            .mapArray(Event.self)
            .observeOn(MainScheduler.instance)
    }

    func userPerformedEvents(username: String, page: Int) -> Observable<[Event]> {
        return provider.request(.userPerformedEvents(username: username, page: page))
            .mapArray(Event.self)
            .observeOn(MainScheduler.instance)
    }
}

extension Api {
    // MARK: - Authentication is required

    func profile() -> Observable<User> {
        return provider.request(.profile)
            .mapObject(User.self)
            .observeOn(MainScheduler.instance)
    }

    func notifications(all: Bool, participating: Bool, page: Int) -> Observable<[Notification]> {
        return provider.request(.notifications(all: all, participating: participating, page: page))
            .mapArray(Notification.self)
            .observeOn(MainScheduler.instance)
    }

    func repositoryNotifications(fullName: String, all: Bool, participating: Bool, page: Int) -> Observable<[Notification]> {
        return provider.request(.notifications(all: all, participating: participating, page: page))
            .mapArray(Notification.self)
            .observeOn(MainScheduler.instance)
    }
}
