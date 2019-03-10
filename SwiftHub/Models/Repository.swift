//
//  Repository.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//
//  Model file Generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper

struct Repository: Mappable {

    var archived: Bool?
    var cloneUrl: String?
    var createdAt: Date?
    var defaultBranch: String?
    var descriptionField: String?
    var fork: Bool?
    var forks: Int?
    var forksCount: Int?
    var fullname: String?
    var hasDownloads: Bool?
    var hasIssues: Bool?
    var hasPages: Bool?
    var hasProjects: Bool?
    var hasWiki: Bool?
    var homepage: String?
    var htmlUrl: String?
    var id: Int?
    var language: String?
    var languageColor: String?
    var license: License?
    var name: String?
    var networkCount: Int?
    var nodeId: String?
    var openIssues: Int?
    var openIssuesCount: Int?
    var organization: User?
    var owner: User?
    var privateField: Bool?
    var pushedAt: String?
    var size: Int?
    var sshUrl: String?
    var stargazersCount: Int?
    var subscribersCount: Int?
    var updatedAt: Date?
    var url: String?
    var watchers: Int?
    var watchersCount: Int?

    init?(map: Map) {}
    init() {}

    init(repo: TrendingRepository) {
        name = repo.name
        fullname = repo.fullname
        htmlUrl = repo.url
        descriptionField = repo.descriptionField
        language = repo.language
        stargazersCount = repo.stars
        forks = repo.forks
        if let user = repo.builtBy?.first {
            owner = User(user: user)
        }
    }

    init(graph: SearchRepositoriesQuery.Data.Search.Node.AsRepository?) {
        guard let graph = graph else { return }
        name = graph.name
        fullname = graph.nameWithOwner
        descriptionField = graph.description
        language = graph.primaryLanguage?.name
        languageColor = graph.primaryLanguage?.color
        stargazersCount = graph.stargazers.totalCount
        owner = User()
        owner?.avatarUrl = graph.owner.avatarUrl
    }

    mutating func mapping(map: Map) {
        archived <- map["archived"]
        cloneUrl <- map["clone_url"]
        createdAt <- (map["created_at"], ISO8601DateTransform())
        defaultBranch <- map["default_branch"]
        descriptionField <- map["description"]
        fork <- map["fork"]
        forks <- map["forks"]
        forksCount <- map["forks_count"]
        fullname <- map["full_name"]
        hasDownloads <- map["has_downloads"]
        hasIssues <- map["has_issues"]
        hasPages <- map["has_pages"]
        hasProjects <- map["has_projects"]
        hasWiki <- map["has_wiki"]
        homepage <- map["homepage"]
        htmlUrl <- map["html_url"]
        id <- map["id"]
        language <- map["language"]
        license <- map["license"]
        name <- map["name"]
        networkCount <- map["network_count"]
        nodeId <- map["node_id"]
        openIssues <- map["open_issues"]
        openIssuesCount <- map["open_issues_count"]
        organization <- map["organization"]
        owner <- map["owner"]
        privateField <- map["private"]
        pushedAt <- map["pushed_at"]
        size <- map["size"]
        sshUrl <- map["ssh_url"]
        stargazersCount <- map["stargazers_count"]
        subscribersCount <- map["subscribers_count"]
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
        url <- map["url"]
        watchers <- map["watchers"]
        watchersCount <- map["watchers_count"]
    }
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        return lhs.id == rhs.id
    }
}

struct RepositorySearch: Mappable {

    var items: [Repository] = []
    var totalCount: Int = 0
    var hasNextPage: Bool = false
    var endCursor: String?

    init?(map: Map) {}
    init() {}

    init(graph: SearchRepositoriesQuery.Data.Search) {
        if let repos = graph.nodes?.map({ Repository(graph: $0?.asRepository) }) {
            items = repos
        }
        totalCount = graph.repositoryCount
        hasNextPage = graph.pageInfo.hasNextPage
        endCursor = graph.pageInfo.endCursor
    }

    mutating func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
        hasNextPage <- map["incomplete_results"]
    }
}

struct TrendingRepository: Mappable {

    var author: String?
    var name: String?
    var url: String?
    var descriptionField: String?
    var language: String?
    var languageColor: String?
    var stars: Int?
    var forks: Int?
    var currentPeriodStars: Int?
    var builtBy: [TrendingUser]?

    var fullname: String? {
        return "\(author ?? "")/\(name ?? "")"
    }

    var avatarUrl: String? {
        return builtBy?.first?.avatar
    }

    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        author <- map["author"]
        name <- map["name"]
        url <- map["url"]
        descriptionField <- map["description"]
        language <- map["language"]
        languageColor <- map["languageColor"]
        stars <- map["stars"]
        forks <- map["forks"]
        currentPeriodStars <- map["currentPeriodStars"]
        builtBy <- map["builtBy"]
    }
}

extension TrendingRepository: Equatable {
    static func == (lhs: TrendingRepository, rhs: TrendingRepository) -> Bool {
        return lhs.fullname == rhs.fullname
    }
}
