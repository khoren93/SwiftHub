//
//  CodetabsApi.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/16/20.
//  Copyright © 2020 Khoren Markosyan. All rights reserved.
//

import Foundation
import Moya

enum CodetabsApi {
    case numberOfLines(fullname: String)
}

extension CodetabsApi: TargetType, ProductAPIType {

    var baseURL: URL {
        return Configs.Network.codetabsBaseUrl.url!
    }

    var path: String {
        switch self {
        case .numberOfLines: return "/loc"
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
        case .numberOfLines(let fullname):
            params["github"] = fullname
        }
        return params
    }

    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }

    var sampleData: Data {
        var dataUrl: URL?
        switch self {
        case .numberOfLines: dataUrl = R.file.repositoryNumberOfLinesJson()
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
