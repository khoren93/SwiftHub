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
    func searchRepositories(query: String) -> Observable<RepositorySearch>
    func searchUsers(query: String) -> Observable<UserSearch>
    func repository(owner: String, repo: String) -> Observable<Repository>
    func user(owner: String) -> Observable<User>
    func organization(owner: String) -> Observable<User>
}

class Api: SwiftHubAPI {
    static let shared = Api()
    var provider = Configs.Network.useStaging ? Networking.newStubbingNetworking() : Networking.newDefaultNetworking()
}

extension Api {
    func searchRepositories(query: String) -> Observable<RepositorySearch> {
        return provider.request(.searchRepositories(query: query))
            .mapObject(RepositorySearch.self)
            .observeOn(MainScheduler.instance)
    }

    func searchUsers(query: String) -> Observable<UserSearch> {
        return provider.request(.searchUsers(query: query))
            .mapObject(UserSearch.self)
            .observeOn(MainScheduler.instance)
    }

    func repository(owner: String, repo: String) -> Observable<Repository> {
        return provider.request(.repository(owner: owner, repo: repo))
            .mapObject(Repository.self)
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
}
