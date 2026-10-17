//
//  Language.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/17/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation

private let languageKey = "CurrentLanguageKey"

struct Language: Codable {

    var urlParam: String?
    var name: String?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        urlParam = map["urlParam"]
        name = map["name"]
    }

    func encode(to encoder: Encoder) throws {
        var map = encoder.container(keyedBy: JSONKey.self)
        try map.encode(urlParam, forKey: "urlParam")
        try map.encode(name, forKey: "name")
    }

    func displayName() -> String {
        return (name.isNilOrEmpty == false ? name: urlParam) ?? ""
    }
}

extension Language {

    func save() {
        if let json = jsonString() {
            UserDefaults.standard.set(json, forKey: languageKey)
        } else {
            logError("Language can't be saved")
        }
    }

    static func currentLanguage() -> Language? {
        if let json = UserDefaults.standard.string(forKey: languageKey),
            let language = Language(jsonString: json) {
            return language
        }
        return nil
    }

    static func removeCurrentLanguage() {
        UserDefaults.standard.removeObject(forKey: languageKey)
    }
}

extension Language: Equatable {
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.urlParam == rhs.urlParam
    }
}

struct Languages {

    var totalCount: Int = 0
    var totalSize: Int = 0
    var languages: [RepoLanguage] = []

    init(graph: RepositoryQuery.Data.Repository.Language?) {
        totalCount = graph?.totalCount ?? 0
        totalSize = graph?.totalSize ?? 0
        languages = (graph?.edges?.map { RepoLanguage(graph: $0) } ?? [])
        languages.sort { (lhs, rhs) -> Bool in
            lhs.size > rhs.size
        }
    }
}

struct RepoLanguage {

    var size: Int = 0
    var name: String?
    var color: String?

    init(graph: RepositoryQuery.Data.Repository.Language.Edge?) {
        size = graph?.size ?? 0
        name = graph?.node.name
        color = graph?.node.color
    }
}
