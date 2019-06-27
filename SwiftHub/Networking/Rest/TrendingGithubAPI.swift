//
//  TrendingGithubAPI.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/17/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import Moya

enum TrendingGithubAPI {
    case trendingRepositories(language: String, since: String)
    case trendingDevelopers(language: String, since: String)
    case languages
}

extension TrendingGithubAPI: TargetType, ProductAPIType {

    var baseURL: URL {
        return Configs.Network.trendingGithubBaseUrl.url!
    }

    var path: String {
        switch self {
        case .trendingRepositories: return "/repositories"
        case .trendingDevelopers: return "/developers"
        case .languages: return "/languages"
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
        var params: [String: Any] = [:]
        switch self {
        case .trendingRepositories(let language, let since),
             .trendingDevelopers(let language, let since):
            params["language"] = language
            params["since"] = since
        default: break
        }
        return params
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        var dataUrl: URL?
        switch self {
        case .trendingRepositories: dataUrl = R.file.repositoryTrendingsJson()
        case .trendingDevelopers: dataUrl = R.file.userTrendingsJson()
        case .languages: dataUrl = R.file.languagesJson()
        }
        if let url = dataUrl, let data = try? Data(contentsOf: url) {
            return data
        }
        return Data()
    }

    public var task: Task {
        if let parameters = parameters {
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        }
        return .requestPlain
    }

    var addXAuth: Bool {
        switch self {
        default: return false
        }
    }
}
