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
