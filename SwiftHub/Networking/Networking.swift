//
//  Networking.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import Alamofire

class OnlineProvider<Target>: RxMoyaProvider<Target> where Target: TargetType {

    fileprivate let online: Observable<Bool>

    init(endpointClosure: @escaping EndpointClosure = MoyaProvider.defaultEndpointMapping,
         requestClosure: @escaping RequestClosure = MoyaProvider.defaultRequestMapping,
         stubClosure: @escaping StubClosure = MoyaProvider.neverStub,
         manager: Manager = RxMoyaProvider<Target>.defaultAlamofireManager(),
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: Observable<Bool> = connectedToInternetOrStubbing()) {

        self.online = online
        super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins, trackInflights: trackInflights)
    }

    override func request(_ token: Target) -> Observable<Moya.Response> {
        let actualRequest = super.request(token)
        return online
            .ignore(value: false)  // Wait until we're online
            .take(1)        // Take 1 to make sure we only invoke the API once.
            .flatMap { _ in // Turn the online state into a network request
                return actualRequest
        }

    }
}

protocol NetworkingType {
    associatedtype T: TargetType, GitHubAPIType
    var provider: OnlineProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = GitHubAPI
    let provider: OnlineProvider<GitHubAPI>
}

struct AuthorizedNetworking: NetworkingType {
    typealias T = GitHubAuthenticatedAPI
    let provider: OnlineProvider<GitHubAuthenticatedAPI>
}

private extension Networking {

    /// Request to fetch and store new XApp token if the current token is missing or expired.
    ///
    /// - parameter defaults:
    ///
    /// - returns:
    func XAppTokenRequest(_ defaults: UserDefaults) -> Observable<String?> {

        var appToken = XAppToken(defaults: defaults)

        // If we have a valid token, return it and forgo a request for a fresh one.
        if appToken.isValid {
            return Observable.just(appToken.token)
        }

        let newTokenRequest = self.provider.request(GitHubAPI.xApp)
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .map { element -> (token: String?, expiry: String?) in
                guard let dictionary = element as? NSDictionary else { return (token: nil, expiry: nil) }

                return (token: dictionary["xapp_token"] as? String, expiry: dictionary["expires_in"] as? String)
            }
            .do(onNext: { (element) in
                    appToken.token = element.0
//                    appToken.expiry = KioskDateFormatter.fromString(element.1 ?? "")
                },
                onError: nil,
                onCompleted: nil,
                onSubscribe: nil,
                onDispose: nil)
            .map { (token, expiry) -> String? in
                return token
            }
            .logError()

        return newTokenRequest
    }
}

// MARK: - "Public" interfaces
extension Networking {

    /// Request to fetch a given target. Ensures that valid XApp tokens exist before making request
    ///
    /// - parameter token:
    /// - parameter defaults:
    ///
    /// - returns:
    func request(_ token: GitHubAPI, defaults: UserDefaults = UserDefaults.standard) -> Observable<Moya.Response> {

        let actualRequest = self.provider.request(token)
        return self.XAppTokenRequest(defaults).flatMap { _ in actualRequest }
    }
}

extension AuthorizedNetworking {
    func request(_ token: GitHubAuthenticatedAPI, defaults: UserDefaults = UserDefaults.standard) -> Observable<Moya.Response> {
        return self.provider.request(token)
    }
}

// MARK: - Static methods
extension NetworkingType {

    static func newDefaultNetworking() -> Networking {
        return Networking(provider: newProvider(plugins))
    }

    static func newAuthorizedNetworking(_ xAccessToken: String) -> AuthorizedNetworking {
        return AuthorizedNetworking(provider: newProvider(authenticatedPlugins, xAccessToken: xAccessToken))
    }

    static func newStubbingNetworking() -> Networking {
        return Networking(provider: OnlineProvider(endpointClosure: endpointsClosure(), requestClosure: Networking.endpointResolver(), stubClosure: MoyaProvider.immediatelyStub, online: .just(true)))
    }

    static func newAuthorizedStubbingNetworking() -> AuthorizedNetworking {
        return AuthorizedNetworking(provider: OnlineProvider(endpointClosure: endpointsClosure(), requestClosure: Networking.endpointResolver(), stubClosure: MoyaProvider.immediatelyStub, online: .just(true)))
    }

    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint<T> where T: TargetType, T: GitHubAPIType {
        return { target in
            var endpoint: Endpoint<T> = Endpoint<T>(url: url(target), sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)

            // If we were given an xAccessToken, add it
            if let xAccessToken = xAccessToken {
                endpoint = endpoint.adding(newHTTPHeaderFields: ["X-Access-Token": xAccessToken])
            }

            // Sign all non-XApp, non-XAuth token requests
            if target.addXAuth {
                return endpoint.adding(newHTTPHeaderFields: ["X-Xapp-Token": XAppToken().token ?? ""])
            } else {
                return endpoint
            }
        }
    }

    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return APIKeys.sharedKeys.stubResponses ? .immediate : .never
    }

    static var plugins: [PluginType] {
        return [
            NetworkLogger(blacklist: { target -> Bool in
                guard let target = target as? GitHubAPI else { return false }

                switch target {
                case .ping: return true
                default: return false
                }
            })
        ]
    }

    static var authenticatedPlugins: [PluginType] {
        return [NetworkLogger(whitelist: { target -> Bool in
            guard let target = target as? GitHubAuthenticatedAPI else { return false }

            switch target {
            default: return false
            }
        })
        ]
    }

    // (Endpoint<Target>, NSURLRequest -> Void) -> Void
    static func endpointResolver<T>() -> MoyaProvider<T>.RequestClosure where T: TargetType {
        return { (endpoint, closure) in
            var request = endpoint.urlRequest!
            request.httpShouldHandleCookies = false
            closure(.success(request))
        }
    }
}

private func newProvider<T>(_ plugins: [PluginType], xAccessToken: String? = nil) -> OnlineProvider<T> where T: TargetType, T: GitHubAPIType {
    return OnlineProvider(endpointClosure: Networking.endpointsClosure(xAccessToken),
                          requestClosure: Networking.endpointResolver(),
                          stubClosure: Networking.APIKeysBasedStubBehaviour,
                          plugins: plugins)
}
