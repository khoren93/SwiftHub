//
//  StubbedResponsesTests.swift
//  SwiftHubTests
//
//  Created by Khoren Markosyan on 10/18/26.
//  Copyright © 2026 Khoren Markosyan. All rights reserved.
//

import Foundation
import Testing
@testable import SwiftHub

/// Stubbed API responses decode into models with their key fields filled in.
/// Model decoding is lenient (a wrong key gives nil, not an error), so the fields are checked explicitly.
struct StubbedResponsesTests {

    private func decode<T: Decodable>(_ type: T.Type, from file: String) throws -> T {
        let data = try #require(stubbedResponse(file) as Data?, "missing \(file).json")
        return try JSONDecoder.swiftHub.decode(type, from: data)
    }

    // MARK: - Repositories

    @Test func repository() throws {
        let repository = try decode(Repository.self, from: "Repository")
        #expect(repository.fullname != nil)
        #expect(repository.owner?.login != nil)
        #expect(repository.createdAt != nil)
        #expect(repository.stargazersCount != nil)
        #expect(repository.license?.name != nil)
    }

    @Test(arguments: ["RepositoryForks", "UserRepositories", "UserRepositoriesStarred", "UserRepositoriesWatching"])
    func repositories(file: String) throws {
        let repositories = try decode([Repository].self, from: file)
        #expect(!repositories.isEmpty)
        for repository in repositories {
            #expect(repository.fullname != nil)
            #expect(repository.owner?.login != nil)
            #expect(repository.updatedAt != nil)
        }
    }

    @Test func repositorySearch() throws {
        let search = try decode(RepositorySearch.self, from: "RepositorySearch")
        #expect(search.totalCount > 0)
        #expect(!search.items.isEmpty)
        #expect(search.hasNextPage)
    }

    @Test func contents() throws {
        let contents = try decode([Content].self, from: "RepositoryContents")
        #expect(!contents.isEmpty)
        #expect(contents.allSatisfy { $0.name != nil && $0.type != .unknown })

        let readme = try decode(Content.self, from: "RepositoryReadme")
        #expect(readme.content != nil)
        #expect(readme.encoding == "base64")
    }

    // MARK: - Users

    @Test func user() throws {
        let user = try decode(User.self, from: "User")
        #expect(user.login != nil)
        #expect(user.type == .user)
        #expect(user.createdAt != nil)
        #expect(user.repositoriesCount != nil)

        let profile = try decode(User.self, from: "Profile")
        #expect(profile.login != nil)

        let organization = try decode(User.self, from: "Organization")
        #expect(organization.type == .organization)
        #expect(organization.descriptionField != nil)
    }

    @Test(arguments: ["RepositoryStargazers", "RepositoryWatchers", "RepositoryContributors", "UserFollowers", "UserFollowing"])
    func users(file: String) throws {
        let users = try decode([User].self, from: file)
        #expect(!users.isEmpty)
        #expect(users.allSatisfy { $0.login != nil && $0.avatarUrl != nil })
    }

    @Test func userSearch() throws {
        let search = try decode(UserSearch.self, from: "UserSearch")
        #expect(search.totalCount > 0)
        #expect(!search.items.isEmpty)
    }

    // MARK: - Events

    @Test(arguments: ["Events", "EventsOrganization", "EventsRepository", "EventsUserPerformed", "EventsUserReceived"])
    func events(file: String) throws {
        let events = try decode([Event].self, from: file)
        #expect(!events.isEmpty)
        for event in events {
            #expect(event.id != nil)
            #expect(event.actor?.login != nil)
            #expect(event.createdAt != nil)
            #expect(event.repository?.fullname?.contains("/") == true)
            #expect(event.repository?.owner?.login != nil)
            if event.type != .unknown {
                #expect(event.payload != nil)
            }
        }
    }

    @Test func eventPayloads() throws {
        let events = try decode([Event].self, from: "EventsOrganization")
        let fork = try #require(events.first { $0.type == .fork }?.payload as? ForkPayload)
        #expect(fork.repository?.fullname != nil)
        let create = try #require(events.first { $0.type == .create }?.payload as? CreatePayload)
        #expect(create.ref != nil)
        let pullRequest = try #require(events.first { $0.type == .pullRequest }?.payload as? PullRequestPayload)
        #expect(pullRequest.number != nil)
        #expect(pullRequest.pullRequest?.number != nil)  // the event payload no longer has the title
        let comment = try #require(events.first { $0.type == .issueComment }?.payload as? IssueCommentPayload)
        #expect(comment.issue?.number != nil)
        #expect(comment.comment?.body != nil)
        let push = try #require(events.first { $0.type == .push }?.payload as? PushPayload)
        #expect(push.ref != nil)
    }

    // MARK: - Issues and pull requests

    @Test func issues() throws {
        let issues = try decode([SwiftHub.Issue].self, from: "RepositoryIssues")
        #expect(!issues.isEmpty)
        #expect(issues.allSatisfy { $0.number != nil && $0.title != nil && $0.user?.login != nil && $0.createdAt != nil })

        let issue = try decode(SwiftHub.Issue.self, from: "RepositoryIssue")
        #expect(issue.number != nil)
        #expect(issue.labels != nil)
    }

    @Test func pullRequests() throws {
        let pullRequests = try decode([PullRequest].self, from: "RepositoryPullRequests")
        #expect(!pullRequests.isEmpty)
        #expect(pullRequests.allSatisfy { $0.number != nil && $0.title != nil && $0.state != .all })

        let pullRequest = try decode(PullRequest.self, from: "RepositoryPullRequest")
        #expect(pullRequest.number != nil)
        #expect(pullRequest.createdAt != nil)
    }

    @Test(arguments: ["RepositoryIssueComments", "RepositoryPullRequestComments"])
    func comments(file: String) throws {
        let comments = try decode([SwiftHub.Comment].self, from: file)
        #expect(!comments.isEmpty)
        #expect(comments.allSatisfy { $0.body != nil && $0.user?.login != nil && $0.createdAt != nil })
    }

    // MARK: - Commits, branches, releases

    @Test func commits() throws {
        let commits = try decode([Commit].self, from: "RepositoryCommits")
        #expect(!commits.isEmpty)
        #expect(commits.allSatisfy { $0.sha != nil && $0.commit?.message != nil && $0.commit?.committer?.date != nil })

        let commit = try decode(Commit.self, from: "RepositoryCommit")
        #expect(commit.stats?.total != nil)
        #expect(commit.files?.isEmpty == false)
    }

    @Test func branches() throws {
        let branches = try decode([Branch].self, from: "RepositoryBranches")
        #expect(!branches.isEmpty)
        #expect(branches.allSatisfy { $0.name != nil && $0.commit?.sha != nil })

        let branch = try decode(Branch.self, from: "RepositoryBranch")
        #expect(branch.name != nil)
    }

    @Test func releases() throws {
        let releases = try decode([Release].self, from: "RepositoryReleases")
        #expect(!releases.isEmpty)
        #expect(releases.allSatisfy { $0.tagName != nil && $0.publishedAt != nil })

        let release = try decode(Release.self, from: "RepositoryRelease")
        #expect(release.author?.login != nil)
    }

    // MARK: - Stored models

    @Test func storedModelsRoundTrip() throws {
        let user = try decode(User.self, from: "User")
        let storedUser = try #require(user.jsonString().flatMap { User(jsonString: $0) })
        #expect(storedUser.login == user.login)
        #expect(storedUser.createdAt == user.createdAt)
        #expect(storedUser.type == user.type)

        var token = Token(personalToken: "token")
        token.isValid = true
        let storedToken = try #require(token.jsonString().flatMap { Token(jsonString: $0) })
        #expect(storedToken.isValid)
        #expect(storedToken.personalToken == "token")
    }
}
