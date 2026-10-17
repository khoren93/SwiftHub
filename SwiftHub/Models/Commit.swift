//
//  Commit.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Commit: Decodable {

    var url: String?
    var commentsUrl: String?
    var commit: CommitInfo?
    var files: [File]?
    var htmlUrl: String?
    var nodeId: String?
//    var parents: [Tree]?
    var sha: String?
    var stats: Stat?
    var author: User?
    var committer: User?

    init() {}

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        url = map["url"]
        commentsUrl = map["comments_url"]
        commit = map["commit"]
        files = map["files"]
        htmlUrl = map["html_url"]
        nodeId = map["node_id"]
//        parents = map["parents"]
        sha = map["sha"]
        stats = map["stats"]
        author = map["author"]
        committer = map["committer"]
    }
}

struct CommitInfo: Decodable {

    var author: Committer?
    var commentCount: Int?
    var committer: Committer?
    var message: String?
    var url: String?
    var verification: Verification?

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        author = map["author"]
        commentCount = map["comment_count"]
        committer = map["committer"]
        message = map["message"]
        url = map["url"]
        verification = map["verification"]
    }
}

struct Stat: Decodable {

    var additions: Int?
    var deletions: Int?
    var total: Int?

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        additions = map["additions"]
        deletions = map["deletions"]
        total = map["total"]
    }
}

struct File: Decodable {

    var additions: Int?
    var blobUrl: String?
    var changes: Int?
    var deletions: Int?
    var filename: String?
    var patch: String?
    var rawUrl: String?
    var status: String?

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        additions = map["additions"]
        blobUrl = map["blob_url"]
        changes = map["changes"]
        deletions = map["deletions"]
        filename = map["filename"]
        patch = map["patch"]
        rawUrl = map["raw_url"]
        status = map["status"]
    }
}

struct Verification: Decodable {

    var payload: String?
    var reason: String?
    var signature: String?
    var verified: Bool?

    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: JSONKey.self)
        payload = map["payload"]
        reason = map["reason"]
        signature = map["signature"]
        verified = map["verified"]
    }
}
