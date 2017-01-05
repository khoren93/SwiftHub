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

protocol GitHubAPIType {
    var addXAuth: Bool { get }
}

enum GitHubAPI {
    case xApp
    case xAuth(email: String, password: String)

    case systemTime
    case ping
}

enum GitHubAuthenticatedAPI {
    case me
}

extension GitHubAPI : TargetType, GitHubAPIType {

    var baseURL: URL {
        return URL(string: Configs.Network.BaseURL)!
    }

    var path: String {
        switch self {
        case .xApp:
            return "/xapp_token"
        case .xAuth:
            return "/oauth2/access_token"

        case .systemTime:
            return "/system/time"
        case .ping:
            return "/system/ping"
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }

    public var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return (Moya.ParameterEncoding as? ParameterEncoding)!
        }
    }

    var sampleData: Data {
        switch self {
        case .xApp:
            return stubbedResponse("XApp")
        case .xAuth:
            return stubbedResponse("XAuth")

        case .systemTime:
            return stubbedResponse("SystemTime")
        case .ping:
            return stubbedResponse("Ping")
        }
    }

    public var task: Task {
        return .request
    }

    var addXAuth: Bool {
        switch self {
        case .xApp: return false
        case .xAuth: return false
        default: return true
        }
    }
}

extension GitHubAuthenticatedAPI: TargetType, GitHubAPIType {

    var baseURL: URL {
        return URL(string: Configs.Network.BaseURL)!
    }

    var path: String {
        switch self {
        case .me:
            return "/me"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        default:
            return nil
        }
    }

    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }

    public var parameterEncoding: ParameterEncoding {
        switch self {
        default:
            return (Moya.ParameterEncoding as? ParameterEncoding)!
        }
    }

    var sampleData: Data {
        switch self {
        case .me:
            return stubbedResponse("Me")
        }
    }

    public var task: Task {
        return .request
    }

    var addXAuth: Bool {
        return true
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
