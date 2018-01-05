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

let gitHubProvider = MoyaProvider<GithubAPI>(plugins: [NetworkLoggerPlugin(verbose: true)])

protocol GithubAPIType {
    var addXAuth: Bool { get }
}

enum GithubAPI {
    case xApp
    case xAuth(email: String, password: String)

    case userRepositories(username: String)
}

extension GithubAPI: TargetType, GithubAPIType {

    var baseURL: URL {
        return URL(string: Configs.Network.BaseURL)!
    }

    var path: String {
        switch self {
        case .xApp:
            return "/xapp_token"
        case .xAuth:
            return "/oauth2/access_token"

        case .userRepositories(let username):
            return "/users/\(username)/repos"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var headers: [String: String]? {
        return nil
    }

    var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        switch self {
        case .xApp:
            return stubbedResponse("XApp")
        case .xAuth:
            return stubbedResponse("XAuth")

        case .userRepositories:
            return stubbedResponse("UserRepositories")
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
        case .xApp, .xAuth:
            return false
        default:
            return true
        }
    }
}

// MARK: - Provider support

func stubbedResponse(_ filename: String) -> Data! {
    @objc class TestClass: NSObject { }

    let bundle = Bundle(for: TestClass.self)
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
