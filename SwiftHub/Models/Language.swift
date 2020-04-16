//
//  Language.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/17/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import ObjectMapper

private let languageKey = "CurrentLanguageKey"

struct Language: Mappable {

    var urlParam: String?
    var name: String?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        urlParam <- map["urlParam"]
        name <- map["name"]
    }

    func displayName() -> String {
        return (name.isNilOrEmpty == false ? name: urlParam) ?? ""
    }
}

extension Language {

    func save() {
        if let json = self.toJSONString() {
            UserDefaults.standard.set(json, forKey: languageKey)
        } else {
            logError("Language can't be saved")
        }
    }

    static func currentLanguage() -> Language? {
        if let json = UserDefaults.standard.string(forKey: languageKey),
            let language = Language(JSONString: json) {
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

struct LanguageLines: Mappable {

    var language: String?
    var files: Int?
    var lines: Int?
    var blanks: Int?
    var comments: Int?
    var linesOfCode: Int?

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        language <- map["language"]
        files <- map["files"]
        lines <- map["lines"]
        blanks <- map["blanks"]
        comments <- map["comments"]
        linesOfCode <- map["linesOfCode"]
    }
}
