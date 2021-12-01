// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public final class RepositoryQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Repository($owner: String!, $name: String!, $qualifiedName: String!) {
      repository(owner: $owner, name: $name) {
        __typename
        name
        nameWithOwner
        description
        url
        homepageUrl
        createdAt
        updatedAt
        viewerHasStarred
        diskUsage
        isFork
        parent {
          __typename
          nameWithOwner
        }
        owner {
          __typename
          login
          avatarUrl
          ... on Organization {
            __typename
            description
          }
        }
        primaryLanguage {
          __typename
          name
          color
        }
        languages(first: 20) {
          __typename
          totalCount
          totalSize
          edges {
            __typename
            size
            node {
              __typename
              name
              color
            }
          }
        }
        licenseInfo {
          __typename
          name
        }
        defaultBranchRef {
          __typename
          name
        }
        stargazers {
          __typename
          totalCount
        }
        forks {
          __typename
          totalCount
        }
        watchers {
          __typename
          totalCount
        }
        mentionableUsers {
          __typename
          totalCount
        }
        issues(states: [OPEN]) {
          __typename
          totalCount
        }
        pullRequests(states: [OPEN]) {
          __typename
          totalCount
        }
        releases {
          __typename
          totalCount
        }
        ref(qualifiedName: $qualifiedName) {
          __typename
          target {
            __typename
            ... on Commit {
              __typename
              history {
                __typename
                totalCount
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Repository"

  public var owner: String
  public var name: String
  public var qualifiedName: String

  public init(owner: String, name: String, qualifiedName: String) {
    self.owner = owner
    self.name = name
    self.qualifiedName = qualifiedName
  }

  public var variables: GraphQLMap? {
    return ["owner": owner, "name": name, "qualifiedName": qualifiedName]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("repository", arguments: ["owner": GraphQLVariable("owner"), "name": GraphQLVariable("name")], type: .object(Repository.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(repository: Repository? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "repository": repository.flatMap { (value: Repository) -> ResultMap in value.resultMap }])
    }

    /// Lookup a given repository by the owner and repository name.
    public var repository: Repository? {
      get {
        return (resultMap["repository"] as? ResultMap).flatMap { Repository(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "repository")
      }
    }

    public struct Repository: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Repository"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(String.self))),
          GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
          GraphQLField("description", type: .scalar(String.self)),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("homepageUrl", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("viewerHasStarred", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("diskUsage", type: .scalar(Int.self)),
          GraphQLField("isFork", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("parent", type: .object(Parent.selections)),
          GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
          GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
          GraphQLField("languages", arguments: ["first": 20], type: .object(Language.selections)),
          GraphQLField("licenseInfo", type: .object(LicenseInfo.selections)),
          GraphQLField("defaultBranchRef", type: .object(DefaultBranchRef.selections)),
          GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
          GraphQLField("forks", type: .nonNull(.object(Fork.selections))),
          GraphQLField("watchers", type: .nonNull(.object(Watcher.selections))),
          GraphQLField("mentionableUsers", type: .nonNull(.object(MentionableUser.selections))),
          GraphQLField("issues", arguments: ["states": ["OPEN"]], type: .nonNull(.object(Issue.selections))),
          GraphQLField("pullRequests", arguments: ["states": ["OPEN"]], type: .nonNull(.object(PullRequest.selections))),
          GraphQLField("releases", type: .nonNull(.object(Release.selections))),
          GraphQLField("ref", arguments: ["qualifiedName": GraphQLVariable("qualifiedName")], type: .object(Ref.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String, nameWithOwner: String, description: String? = nil, url: String, homepageUrl: String? = nil, createdAt: String, updatedAt: String, viewerHasStarred: Bool, diskUsage: Int? = nil, isFork: Bool, parent: Parent? = nil, owner: Owner, primaryLanguage: PrimaryLanguage? = nil, languages: Language? = nil, licenseInfo: LicenseInfo? = nil, defaultBranchRef: DefaultBranchRef? = nil, stargazers: Stargazer, forks: Fork, watchers: Watcher, mentionableUsers: MentionableUser, issues: Issue, pullRequests: PullRequest, releases: Release, ref: Ref? = nil) {
        self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "description": description, "url": url, "homepageUrl": homepageUrl, "createdAt": createdAt, "updatedAt": updatedAt, "viewerHasStarred": viewerHasStarred, "diskUsage": diskUsage, "isFork": isFork, "parent": parent.flatMap { (value: Parent) -> ResultMap in value.resultMap }, "owner": owner.resultMap, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> ResultMap in value.resultMap }, "languages": languages.flatMap { (value: Language) -> ResultMap in value.resultMap }, "licenseInfo": licenseInfo.flatMap { (value: LicenseInfo) -> ResultMap in value.resultMap }, "defaultBranchRef": defaultBranchRef.flatMap { (value: DefaultBranchRef) -> ResultMap in value.resultMap }, "stargazers": stargazers.resultMap, "forks": forks.resultMap, "watchers": watchers.resultMap, "mentionableUsers": mentionableUsers.resultMap, "issues": issues.resultMap, "pullRequests": pullRequests.resultMap, "releases": releases.resultMap, "ref": ref.flatMap { (value: Ref) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The name of the repository.
      public var name: String {
        get {
          return resultMap["name"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// The repository's name with owner.
      public var nameWithOwner: String {
        get {
          return resultMap["nameWithOwner"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "nameWithOwner")
        }
      }

      /// The description of the repository.
      public var description: String? {
        get {
          return resultMap["description"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "description")
        }
      }

      /// The HTTP URL for this repository
      public var url: String {
        get {
          return resultMap["url"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      /// The repository's URL.
      public var homepageUrl: String? {
        get {
          return resultMap["homepageUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "homepageUrl")
        }
      }

      /// Identifies the date and time when the object was created.
      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// Identifies the date and time when the object was last updated.
      public var updatedAt: String {
        get {
          return resultMap["updatedAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      /// Returns a boolean indicating whether the viewing user has starred this starrable.
      public var viewerHasStarred: Bool {
        get {
          return resultMap["viewerHasStarred"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "viewerHasStarred")
        }
      }

      /// The number of kilobytes this repository occupies on disk.
      public var diskUsage: Int? {
        get {
          return resultMap["diskUsage"] as? Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "diskUsage")
        }
      }

      /// Identifies if the repository is a fork.
      public var isFork: Bool {
        get {
          return resultMap["isFork"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isFork")
        }
      }

      /// The repository parent, if this is a fork.
      public var parent: Parent? {
        get {
          return (resultMap["parent"] as? ResultMap).flatMap { Parent(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "parent")
        }
      }

      /// The User owner of the repository.
      public var owner: Owner {
        get {
          return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "owner")
        }
      }

      /// The primary language of the repository's code.
      public var primaryLanguage: PrimaryLanguage? {
        get {
          return (resultMap["primaryLanguage"] as? ResultMap).flatMap { PrimaryLanguage(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "primaryLanguage")
        }
      }

      /// A list containing a breakdown of the language composition of the repository.
      public var languages: Language? {
        get {
          return (resultMap["languages"] as? ResultMap).flatMap { Language(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "languages")
        }
      }

      /// The license associated with the repository
      public var licenseInfo: LicenseInfo? {
        get {
          return (resultMap["licenseInfo"] as? ResultMap).flatMap { LicenseInfo(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "licenseInfo")
        }
      }

      /// The Ref associated with the repository's default branch.
      public var defaultBranchRef: DefaultBranchRef? {
        get {
          return (resultMap["defaultBranchRef"] as? ResultMap).flatMap { DefaultBranchRef(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "defaultBranchRef")
        }
      }

      /// A list of users who have starred this starrable.
      public var stargazers: Stargazer {
        get {
          return Stargazer(unsafeResultMap: resultMap["stargazers"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "stargazers")
        }
      }

      /// A list of direct forked repositories.
      public var forks: Fork {
        get {
          return Fork(unsafeResultMap: resultMap["forks"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "forks")
        }
      }

      /// A list of users watching the repository.
      public var watchers: Watcher {
        get {
          return Watcher(unsafeResultMap: resultMap["watchers"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "watchers")
        }
      }

      /// A list of Users that can be mentioned in the context of the repository.
      public var mentionableUsers: MentionableUser {
        get {
          return MentionableUser(unsafeResultMap: resultMap["mentionableUsers"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "mentionableUsers")
        }
      }

      /// A list of issues that have been opened in the repository.
      public var issues: Issue {
        get {
          return Issue(unsafeResultMap: resultMap["issues"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "issues")
        }
      }

      /// A list of pull requests that have been opened in the repository.
      public var pullRequests: PullRequest {
        get {
          return PullRequest(unsafeResultMap: resultMap["pullRequests"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pullRequests")
        }
      }

      /// List of releases which are dependent on this repository.
      public var releases: Release {
        get {
          return Release(unsafeResultMap: resultMap["releases"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "releases")
        }
      }

      /// Fetch a given ref from the repository
      public var ref: Ref? {
        get {
          return (resultMap["ref"] as? ResultMap).flatMap { Ref(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "ref")
        }
      }

      public struct Parent: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Repository"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nameWithOwner: String) {
          self.init(unsafeResultMap: ["__typename": "Repository", "nameWithOwner": nameWithOwner])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The repository's name with owner.
        public var nameWithOwner: String {
          get {
            return resultMap["nameWithOwner"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "nameWithOwner")
          }
        }
      }

      public struct Owner: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Organization", "User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLTypeCase(
              variants: ["Organization": AsOrganization.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("login", type: .nonNull(.scalar(String.self))),
                GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public static func makeUser(login: String, avatarUrl: String) -> Owner {
          return Owner(unsafeResultMap: ["__typename": "User", "login": login, "avatarUrl": avatarUrl])
        }

        public static func makeOrganization(login: String, avatarUrl: String, description: String? = nil) -> Owner {
          return Owner(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl, "description": description])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The username used to login.
        public var login: String {
          get {
            return resultMap["login"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "login")
          }
        }

        /// A URL pointing to the owner's public avatar.
        public var avatarUrl: String {
          get {
            return resultMap["avatarUrl"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "avatarUrl")
          }
        }

        public var asOrganization: AsOrganization? {
          get {
            if !AsOrganization.possibleTypes.contains(__typename) { return nil }
            return AsOrganization(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsOrganization: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Organization"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("login", type: .nonNull(.scalar(String.self))),
              GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(login: String, avatarUrl: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Organization", "login": login, "avatarUrl": avatarUrl, "description": description])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The organization's login name.
          public var login: String {
            get {
              return resultMap["login"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "login")
            }
          }

          /// A URL pointing to the organization's public avatar.
          public var avatarUrl: String {
            get {
              return resultMap["avatarUrl"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "avatarUrl")
            }
          }

          /// The organization's public profile description.
          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }
      }

      public struct PrimaryLanguage: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Language"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
            GraphQLField("color", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String, color: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "Language", "name": name, "color": color])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The name of the current language.
        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }

        /// The color defined for the current language.
        public var color: String? {
          get {
            return resultMap["color"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "color")
          }
        }
      }

      public struct Language: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["LanguageConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
            GraphQLField("totalSize", type: .nonNull(.scalar(Int.self))),
            GraphQLField("edges", type: .list(.object(Edge.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int, totalSize: Int, edges: [Edge?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "LanguageConnection", "totalCount": totalCount, "totalSize": totalSize, "edges": edges.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }

        /// The total size in bytes of files written in that language.
        public var totalSize: Int {
          get {
            return resultMap["totalSize"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalSize")
          }
        }

        /// A list of edges.
        public var edges: [Edge?]? {
          get {
            return (resultMap["edges"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Edge?] in value.map { (value: ResultMap?) -> Edge? in value.flatMap { (value: ResultMap) -> Edge in Edge(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Edge?]) -> [ResultMap?] in value.map { (value: Edge?) -> ResultMap? in value.flatMap { (value: Edge) -> ResultMap in value.resultMap } } }, forKey: "edges")
          }
        }

        public struct Edge: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["LanguageEdge"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("size", type: .nonNull(.scalar(Int.self))),
              GraphQLField("node", type: .nonNull(.object(Node.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(size: Int, node: Node) {
            self.init(unsafeResultMap: ["__typename": "LanguageEdge", "size": size, "node": node.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The number of bytes of code written in the language.
          public var size: Int {
            get {
              return resultMap["size"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "size")
            }
          }

          public var node: Node {
            get {
              return Node(unsafeResultMap: resultMap["node"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "node")
            }
          }

          public struct Node: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Language"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("color", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String, color: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Language", "name": name, "color": color])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the current language.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The color defined for the current language.
            public var color: String? {
              get {
                return resultMap["color"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "color")
              }
            }
          }
        }
      }

      public struct LicenseInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["License"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "License", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The license full name specified by <https://spdx.org/licenses>
        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct DefaultBranchRef: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Ref"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("name", type: .nonNull(.scalar(String.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(name: String) {
          self.init(unsafeResultMap: ["__typename": "Ref", "name": name])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The ref name.
        public var name: String {
          get {
            return resultMap["name"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "name")
          }
        }
      }

      public struct Stargazer: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StargazerConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "StargazerConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Fork: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Watcher: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UserConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "UserConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct MentionableUser: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UserConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "UserConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["IssueConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "IssueConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct PullRequest: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PullRequestConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "PullRequestConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Release: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ReleaseConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "ReleaseConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Ref: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Ref"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("target", type: .nonNull(.object(Target.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(target: Target) {
          self.init(unsafeResultMap: ["__typename": "Ref", "target": target.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// The object the ref points to.
        public var target: Target {
          get {
            return Target(unsafeResultMap: resultMap["target"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "target")
          }
        }

        public struct Target: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Blob", "Commit", "Tag", "Tree"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["Commit": AsCommit.selections],
                default: [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                ]
              )
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeBlob() -> Target {
            return Target(unsafeResultMap: ["__typename": "Blob"])
          }

          public static func makeTag() -> Target {
            return Target(unsafeResultMap: ["__typename": "Tag"])
          }

          public static func makeTree() -> Target {
            return Target(unsafeResultMap: ["__typename": "Tree"])
          }

          public static func makeCommit(history: AsCommit.History) -> Target {
            return Target(unsafeResultMap: ["__typename": "Commit", "history": history.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asCommit: AsCommit? {
            get {
              if !AsCommit.possibleTypes.contains(__typename) { return nil }
              return AsCommit(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsCommit: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Commit"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("history", type: .nonNull(.object(History.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(history: History) {
              self.init(unsafeResultMap: ["__typename": "Commit", "history": history.resultMap])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The linear commit history starting from (and including) this commit, in the same order as `git log`.
            public var history: History {
              get {
                return History(unsafeResultMap: resultMap["history"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "history")
              }
            }

            public struct History: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["CommitHistoryConnection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(totalCount: Int) {
                self.init(unsafeResultMap: ["__typename": "CommitHistoryConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return resultMap["totalCount"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "totalCount")
                }
              }
            }
          }
        }
      }
    }
  }
}

public final class SearchRepositoriesQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SearchRepositories($query: String!, $before: String) {
      search(first: 20, query: $query, type: REPOSITORY, before: $before) {
        __typename
        repositoryCount
        pageInfo {
          __typename
          endCursor
          hasNextPage
        }
        nodes {
          __typename
          ... on Repository {
            __typename
            name
            nameWithOwner
            description
            owner {
              __typename
              avatarUrl
              ... on Organization {
                __typename
                description
              }
            }
            updatedAt
            viewerHasStarred
            primaryLanguage {
              __typename
              name
              color
            }
            stargazers {
              __typename
              totalCount
            }
          }
        }
      }
    }
    """

  public let operationName: String = "SearchRepositories"

  public var query: String
  public var before: String?

  public init(query: String, before: String? = nil) {
    self.query = query
    self.before = before
  }

  public var variables: GraphQLMap? {
    return ["query": query, "before": before]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("search", arguments: ["first": 20, "query": GraphQLVariable("query"), "type": "REPOSITORY", "before": GraphQLVariable("before")], type: .nonNull(.object(Search.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(search: Search) {
      self.init(unsafeResultMap: ["__typename": "Query", "search": search.resultMap])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(unsafeResultMap: resultMap["search"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResultItemConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("repositoryCount", type: .nonNull(.scalar(Int.self))),
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          GraphQLField("nodes", type: .list(.object(Node.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(repositoryCount: Int, pageInfo: PageInfo, nodes: [Node?]? = nil) {
        self.init(unsafeResultMap: ["__typename": "SearchResultItemConnection", "repositoryCount": repositoryCount, "pageInfo": pageInfo.resultMap, "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The number of repositories that matched the search query.
      public var repositoryCount: Int {
        get {
          return resultMap["repositoryCount"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "repositoryCount")
        }
      }

      /// Information to aid in pagination.
      public var pageInfo: PageInfo {
        get {
          return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
        }
      }

      /// A list of nodes.
      public var nodes: [Node?]? {
        get {
          return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PageInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("endCursor", type: .scalar(String.self)),
            GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(endCursor: String? = nil, hasNextPage: Bool) {
          self.init(unsafeResultMap: ["__typename": "PageInfo", "endCursor": endCursor, "hasNextPage": hasNextPage])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? {
          get {
            return resultMap["endCursor"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endCursor")
          }
        }

        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool {
          get {
            return resultMap["hasNextPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasNextPage")
          }
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["App", "Issue", "MarketplaceListing", "Organization", "PullRequest", "Repository", "User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLTypeCase(
              variants: ["Repository": AsRepository.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public static func makeApp() -> Node {
          return Node(unsafeResultMap: ["__typename": "App"])
        }

        public static func makeIssue() -> Node {
          return Node(unsafeResultMap: ["__typename": "Issue"])
        }

        public static func makeMarketplaceListing() -> Node {
          return Node(unsafeResultMap: ["__typename": "MarketplaceListing"])
        }

        public static func makeOrganization() -> Node {
          return Node(unsafeResultMap: ["__typename": "Organization"])
        }

        public static func makePullRequest() -> Node {
          return Node(unsafeResultMap: ["__typename": "PullRequest"])
        }

        public static func makeUser() -> Node {
          return Node(unsafeResultMap: ["__typename": "User"])
        }

        public static func makeRepository(name: String, nameWithOwner: String, description: String? = nil, owner: AsRepository.Owner, updatedAt: String, viewerHasStarred: Bool, primaryLanguage: AsRepository.PrimaryLanguage? = nil, stargazers: AsRepository.Stargazer) -> Node {
          return Node(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "description": description, "owner": owner.resultMap, "updatedAt": updatedAt, "viewerHasStarred": viewerHasStarred, "primaryLanguage": primaryLanguage.flatMap { (value: AsRepository.PrimaryLanguage) -> ResultMap in value.resultMap }, "stargazers": stargazers.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var asRepository: AsRepository? {
          get {
            if !AsRepository.possibleTypes.contains(__typename) { return nil }
            return AsRepository(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsRepository: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Repository"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .nonNull(.scalar(String.self))),
              GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
              GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
              GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
              GraphQLField("viewerHasStarred", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
              GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String, nameWithOwner: String, description: String? = nil, owner: Owner, updatedAt: String, viewerHasStarred: Bool, primaryLanguage: PrimaryLanguage? = nil, stargazers: Stargazer) {
            self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "description": description, "owner": owner.resultMap, "updatedAt": updatedAt, "viewerHasStarred": viewerHasStarred, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> ResultMap in value.resultMap }, "stargazers": stargazers.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The name of the repository.
          public var name: String {
            get {
              return resultMap["name"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// The repository's name with owner.
          public var nameWithOwner: String {
            get {
              return resultMap["nameWithOwner"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "nameWithOwner")
            }
          }

          /// The description of the repository.
          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }

          /// The User owner of the repository.
          public var owner: Owner {
            get {
              return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "owner")
            }
          }

          /// Identifies the date and time when the object was last updated.
          public var updatedAt: String {
            get {
              return resultMap["updatedAt"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "updatedAt")
            }
          }

          /// Returns a boolean indicating whether the viewing user has starred this starrable.
          public var viewerHasStarred: Bool {
            get {
              return resultMap["viewerHasStarred"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "viewerHasStarred")
            }
          }

          /// The primary language of the repository's code.
          public var primaryLanguage: PrimaryLanguage? {
            get {
              return (resultMap["primaryLanguage"] as? ResultMap).flatMap { PrimaryLanguage(unsafeResultMap: $0) }
            }
            set {
              resultMap.updateValue(newValue?.resultMap, forKey: "primaryLanguage")
            }
          }

          /// A list of users who have starred this starrable.
          public var stargazers: Stargazer {
            get {
              return Stargazer(unsafeResultMap: resultMap["stargazers"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "stargazers")
            }
          }

          public struct Owner: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Organization", "User"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLTypeCase(
                  variants: ["Organization": AsOrganization.selections],
                  default: [
                    GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                    GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                  ]
                )
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public static func makeUser(avatarUrl: String) -> Owner {
              return Owner(unsafeResultMap: ["__typename": "User", "avatarUrl": avatarUrl])
            }

            public static func makeOrganization(avatarUrl: String, description: String? = nil) -> Owner {
              return Owner(unsafeResultMap: ["__typename": "Organization", "avatarUrl": avatarUrl, "description": description])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// A URL pointing to the owner's public avatar.
            public var avatarUrl: String {
              get {
                return resultMap["avatarUrl"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "avatarUrl")
              }
            }

            public var asOrganization: AsOrganization? {
              get {
                if !AsOrganization.possibleTypes.contains(__typename) { return nil }
                return AsOrganization(unsafeResultMap: resultMap)
              }
              set {
                guard let newValue = newValue else { return }
                resultMap = newValue.resultMap
              }
            }

            public struct AsOrganization: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Organization"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("description", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(avatarUrl: String, description: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Organization", "avatarUrl": avatarUrl, "description": description])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// A URL pointing to the organization's public avatar.
              public var avatarUrl: String {
                get {
                  return resultMap["avatarUrl"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "avatarUrl")
                }
              }

              /// The organization's public profile description.
              public var description: String? {
                get {
                  return resultMap["description"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "description")
                }
              }
            }
          }

          public struct PrimaryLanguage: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Language"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("color", type: .scalar(String.self)),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String, color: String? = nil) {
              self.init(unsafeResultMap: ["__typename": "Language", "name": name, "color": color])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the current language.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The color defined for the current language.
            public var color: String? {
              get {
                return resultMap["color"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "color")
              }
            }
          }

          public struct Stargazer: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["StargazerConnection"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(totalCount: Int) {
              self.init(unsafeResultMap: ["__typename": "StargazerConnection", "totalCount": totalCount])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Identifies the total count of items in the connection.
            public var totalCount: Int {
              get {
                return resultMap["totalCount"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "totalCount")
              }
            }
          }
        }
      }
    }
  }
}

public final class SearchUsersQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query SearchUsers($query: String!, $before: String) {
      search(first: 20, query: $query, type: USER, before: $before) {
        __typename
        nodes {
          __typename
          ... on User {
            __typename
            name
            login
            avatarUrl
            viewerCanFollow
            viewerIsFollowing
            followers {
              __typename
              totalCount
            }
            repositories {
              __typename
              totalCount
            }
          }
        }
        pageInfo {
          __typename
          endCursor
          hasNextPage
        }
        userCount
      }
    }
    """

  public let operationName: String = "SearchUsers"

  public var query: String
  public var before: String?

  public init(query: String, before: String? = nil) {
    self.query = query
    self.before = before
  }

  public var variables: GraphQLMap? {
    return ["query": query, "before": before]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("search", arguments: ["first": 20, "query": GraphQLVariable("query"), "type": "USER", "before": GraphQLVariable("before")], type: .nonNull(.object(Search.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(search: Search) {
      self.init(unsafeResultMap: ["__typename": "Query", "search": search.resultMap])
    }

    /// Perform a search across resources.
    public var search: Search {
      get {
        return Search(unsafeResultMap: resultMap["search"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "search")
      }
    }

    public struct Search: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SearchResultItemConnection"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nodes", type: .list(.object(Node.selections))),
          GraphQLField("pageInfo", type: .nonNull(.object(PageInfo.selections))),
          GraphQLField("userCount", type: .nonNull(.scalar(Int.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nodes: [Node?]? = nil, pageInfo: PageInfo, userCount: Int) {
        self.init(unsafeResultMap: ["__typename": "SearchResultItemConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, "pageInfo": pageInfo.resultMap, "userCount": userCount])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// A list of nodes.
      public var nodes: [Node?]? {
        get {
          return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
        }
      }

      /// Information to aid in pagination.
      public var pageInfo: PageInfo {
        get {
          return PageInfo(unsafeResultMap: resultMap["pageInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pageInfo")
        }
      }

      /// The number of users that matched the search query.
      public var userCount: Int {
        get {
          return resultMap["userCount"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "userCount")
        }
      }

      public struct Node: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["App", "Issue", "MarketplaceListing", "Organization", "PullRequest", "Repository", "User"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLTypeCase(
              variants: ["User": AsUser.selections],
              default: [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              ]
            )
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public static func makeApp() -> Node {
          return Node(unsafeResultMap: ["__typename": "App"])
        }

        public static func makeIssue() -> Node {
          return Node(unsafeResultMap: ["__typename": "Issue"])
        }

        public static func makeMarketplaceListing() -> Node {
          return Node(unsafeResultMap: ["__typename": "MarketplaceListing"])
        }

        public static func makeOrganization() -> Node {
          return Node(unsafeResultMap: ["__typename": "Organization"])
        }

        public static func makePullRequest() -> Node {
          return Node(unsafeResultMap: ["__typename": "PullRequest"])
        }

        public static func makeRepository() -> Node {
          return Node(unsafeResultMap: ["__typename": "Repository"])
        }

        public static func makeUser(name: String? = nil, login: String, avatarUrl: String, viewerCanFollow: Bool, viewerIsFollowing: Bool, followers: AsUser.Follower, repositories: AsUser.Repository) -> Node {
          return Node(unsafeResultMap: ["__typename": "User", "name": name, "login": login, "avatarUrl": avatarUrl, "viewerCanFollow": viewerCanFollow, "viewerIsFollowing": viewerIsFollowing, "followers": followers.resultMap, "repositories": repositories.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var asUser: AsUser? {
          get {
            if !AsUser.possibleTypes.contains(__typename) { return nil }
            return AsUser(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap = newValue.resultMap
          }
        }

        public struct AsUser: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["User"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("login", type: .nonNull(.scalar(String.self))),
              GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
              GraphQLField("viewerCanFollow", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("viewerIsFollowing", type: .nonNull(.scalar(Bool.self))),
              GraphQLField("followers", type: .nonNull(.object(Follower.selections))),
              GraphQLField("repositories", type: .nonNull(.object(Repository.selections))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, login: String, avatarUrl: String, viewerCanFollow: Bool, viewerIsFollowing: Bool, followers: Follower, repositories: Repository) {
            self.init(unsafeResultMap: ["__typename": "User", "name": name, "login": login, "avatarUrl": avatarUrl, "viewerCanFollow": viewerCanFollow, "viewerIsFollowing": viewerIsFollowing, "followers": followers.resultMap, "repositories": repositories.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The user's public profile name.
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// The username used to login.
          public var login: String {
            get {
              return resultMap["login"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "login")
            }
          }

          /// A URL pointing to the user's public avatar.
          public var avatarUrl: String {
            get {
              return resultMap["avatarUrl"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "avatarUrl")
            }
          }

          /// Whether or not the viewer is able to follow the user.
          public var viewerCanFollow: Bool {
            get {
              return resultMap["viewerCanFollow"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "viewerCanFollow")
            }
          }

          /// Whether or not this user is followed by the viewer.
          public var viewerIsFollowing: Bool {
            get {
              return resultMap["viewerIsFollowing"]! as! Bool
            }
            set {
              resultMap.updateValue(newValue, forKey: "viewerIsFollowing")
            }
          }

          /// A list of users the given user is followed by.
          public var followers: Follower {
            get {
              return Follower(unsafeResultMap: resultMap["followers"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "followers")
            }
          }

          /// A list of repositories that the user owns.
          public var repositories: Repository {
            get {
              return Repository(unsafeResultMap: resultMap["repositories"]! as! ResultMap)
            }
            set {
              resultMap.updateValue(newValue.resultMap, forKey: "repositories")
            }
          }

          public struct Follower: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["FollowerConnection"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(totalCount: Int) {
              self.init(unsafeResultMap: ["__typename": "FollowerConnection", "totalCount": totalCount])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Identifies the total count of items in the connection.
            public var totalCount: Int {
              get {
                return resultMap["totalCount"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "totalCount")
              }
            }
          }

          public struct Repository: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["RepositoryConnection"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(totalCount: Int) {
              self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "totalCount": totalCount])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// Identifies the total count of items in the connection.
            public var totalCount: Int {
              get {
                return resultMap["totalCount"]! as! Int
              }
              set {
                resultMap.updateValue(newValue, forKey: "totalCount")
              }
            }
          }
        }
      }

      public struct PageInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PageInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("endCursor", type: .scalar(String.self)),
            GraphQLField("hasNextPage", type: .nonNull(.scalar(Bool.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(endCursor: String? = nil, hasNextPage: Bool) {
          self.init(unsafeResultMap: ["__typename": "PageInfo", "endCursor": endCursor, "hasNextPage": hasNextPage])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? {
          get {
            return resultMap["endCursor"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "endCursor")
          }
        }

        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool {
          get {
            return resultMap["hasNextPage"]! as! Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "hasNextPage")
          }
        }
      }
    }
  }
}

public final class ViewerQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query Viewer {
      viewer {
        __typename
        id
        name
        login
        avatarUrl
        url
        websiteUrl
        bio
        company
        email
        location
        createdAt
        updatedAt
        viewerCanFollow
        viewerIsFollowing
        isViewer
        followers {
          __typename
          totalCount
        }
        following {
          __typename
          totalCount
        }
        starredRepositories {
          __typename
          totalCount
        }
        issues {
          __typename
          totalCount
        }
        repositories {
          __typename
          totalCount
        }
        watching {
          __typename
          totalCount
        }
        contributionsCollection {
          __typename
          totalRepositoryContributions
        }
        pinnedItems(first: 6) {
          __typename
          nodes {
            __typename
            ... on Repository {
              __typename
              name
              nameWithOwner
              description
              owner {
                __typename
                avatarUrl
              }
              updatedAt
              viewerHasStarred
              primaryLanguage {
                __typename
                name
                color
              }
              stargazers {
                __typename
                totalCount
              }
            }
          }
        }
        organizations(first: 10) {
          __typename
          nodes {
            __typename
            name
            login
            avatarUrl
            ... on Organization {
              __typename
              description
            }
          }
        }
        contributionsCollection {
          __typename
          contributionCalendar {
            __typename
            totalContributions
            months {
              __typename
              name
            }
            weeks {
              __typename
              contributionDays {
                __typename
                color
                contributionCount
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "Viewer"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("viewer", type: .nonNull(.object(Viewer.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(viewer: Viewer) {
      self.init(unsafeResultMap: ["__typename": "Query", "viewer": viewer.resultMap])
    }

    /// The currently authenticated user.
    public var viewer: Viewer {
      get {
        return Viewer(unsafeResultMap: resultMap["viewer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "viewer")
      }
    }

    public struct Viewer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("login", type: .nonNull(.scalar(String.self))),
          GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("websiteUrl", type: .scalar(String.self)),
          GraphQLField("bio", type: .scalar(String.self)),
          GraphQLField("company", type: .scalar(String.self)),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("location", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("viewerCanFollow", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("viewerIsFollowing", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("isViewer", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("followers", type: .nonNull(.object(Follower.selections))),
          GraphQLField("following", type: .nonNull(.object(Following.selections))),
          GraphQLField("starredRepositories", type: .nonNull(.object(StarredRepository.selections))),
          GraphQLField("issues", type: .nonNull(.object(Issue.selections))),
          GraphQLField("repositories", type: .nonNull(.object(Repository.selections))),
          GraphQLField("watching", type: .nonNull(.object(Watching.selections))),
          GraphQLField("contributionsCollection", type: .nonNull(.object(ContributionsCollection.selections))),
          GraphQLField("pinnedItems", arguments: ["first": 6], type: .nonNull(.object(PinnedItem.selections))),
          GraphQLField("organizations", arguments: ["first": 10], type: .nonNull(.object(Organization.selections))),
          GraphQLField("contributionsCollection", type: .nonNull(.object(ContributionsCollection.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: GraphQLID, name: String? = nil, login: String, avatarUrl: String, url: String, websiteUrl: String? = nil, bio: String? = nil, company: String? = nil, email: String, location: String? = nil, createdAt: String, updatedAt: String, viewerCanFollow: Bool, viewerIsFollowing: Bool, isViewer: Bool, followers: Follower, following: Following, starredRepositories: StarredRepository, issues: Issue, repositories: Repository, watching: Watching, contributionsCollection: ContributionsCollection, pinnedItems: PinnedItem, organizations: Organization) {
        self.init(unsafeResultMap: ["__typename": "User", "id": id, "name": name, "login": login, "avatarUrl": avatarUrl, "url": url, "websiteUrl": websiteUrl, "bio": bio, "company": company, "email": email, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "viewerCanFollow": viewerCanFollow, "viewerIsFollowing": viewerIsFollowing, "isViewer": isViewer, "followers": followers.resultMap, "following": following.resultMap, "starredRepositories": starredRepositories.resultMap, "issues": issues.resultMap, "repositories": repositories.resultMap, "watching": watching.resultMap, "contributionsCollection": contributionsCollection.resultMap, "pinnedItems": pinnedItems.resultMap, "organizations": organizations.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return resultMap["id"]! as! GraphQLID
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }

      /// The user's public profile name.
      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// The username used to login.
      public var login: String {
        get {
          return resultMap["login"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "login")
        }
      }

      /// A URL pointing to the user's public avatar.
      public var avatarUrl: String {
        get {
          return resultMap["avatarUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "avatarUrl")
        }
      }

      /// The HTTP URL for this user
      public var url: String {
        get {
          return resultMap["url"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      /// A URL pointing to the user's public website/blog.
      public var websiteUrl: String? {
        get {
          return resultMap["websiteUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "websiteUrl")
        }
      }

      /// The user's public profile bio.
      public var bio: String? {
        get {
          return resultMap["bio"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bio")
        }
      }

      /// The user's public profile company.
      public var company: String? {
        get {
          return resultMap["company"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "company")
        }
      }

      /// The user's publicly visible profile email.
      public var email: String {
        get {
          return resultMap["email"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      /// The user's public profile location.
      public var location: String? {
        get {
          return resultMap["location"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "location")
        }
      }

      /// Identifies the date and time when the object was created.
      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// Identifies the date and time when the object was last updated.
      public var updatedAt: String {
        get {
          return resultMap["updatedAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      /// Whether or not the viewer is able to follow the user.
      public var viewerCanFollow: Bool {
        get {
          return resultMap["viewerCanFollow"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "viewerCanFollow")
        }
      }

      /// Whether or not this user is followed by the viewer.
      public var viewerIsFollowing: Bool {
        get {
          return resultMap["viewerIsFollowing"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "viewerIsFollowing")
        }
      }

      /// Whether or not this user is the viewing user.
      public var isViewer: Bool {
        get {
          return resultMap["isViewer"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isViewer")
        }
      }

      /// A list of users the given user is followed by.
      public var followers: Follower {
        get {
          return Follower(unsafeResultMap: resultMap["followers"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "followers")
        }
      }

      /// A list of users the given user is following.
      public var following: Following {
        get {
          return Following(unsafeResultMap: resultMap["following"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "following")
        }
      }

      /// Repositories the user has starred.
      public var starredRepositories: StarredRepository {
        get {
          return StarredRepository(unsafeResultMap: resultMap["starredRepositories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "starredRepositories")
        }
      }

      /// A list of issues associated with this user.
      public var issues: Issue {
        get {
          return Issue(unsafeResultMap: resultMap["issues"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "issues")
        }
      }

      /// A list of repositories that the user owns.
      public var repositories: Repository {
        get {
          return Repository(unsafeResultMap: resultMap["repositories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "repositories")
        }
      }

      /// A list of repositories the given user is watching.
      public var watching: Watching {
        get {
          return Watching(unsafeResultMap: resultMap["watching"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "watching")
        }
      }

      /// The collection of contributions this user has made to different repositories.
      public var contributionsCollection: ContributionsCollection {
        get {
          return ContributionsCollection(unsafeResultMap: resultMap["contributionsCollection"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "contributionsCollection")
        }
      }

      /// A list of repositories and gists this profile owner has pinned to their profile
      public var pinnedItems: PinnedItem {
        get {
          return PinnedItem(unsafeResultMap: resultMap["pinnedItems"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pinnedItems")
        }
      }

      /// A list of organizations the user belongs to.
      public var organizations: Organization {
        get {
          return Organization(unsafeResultMap: resultMap["organizations"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "organizations")
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["FollowerConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "FollowerConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Following: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["FollowingConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "FollowingConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct StarredRepository: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StarredRepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "StarredRepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["IssueConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "IssueConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Watching: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct ContributionsCollection: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ContributionsCollection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalRepositoryContributions", type: .nonNull(.scalar(Int.self))),
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("contributionCalendar", type: .nonNull(.object(ContributionCalendar.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalRepositoryContributions: Int, contributionCalendar: ContributionCalendar) {
          self.init(unsafeResultMap: ["__typename": "ContributionsCollection", "totalRepositoryContributions": totalRepositoryContributions, "contributionCalendar": contributionCalendar.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// How many repositories the user created.
        public var totalRepositoryContributions: Int {
          get {
            return resultMap["totalRepositoryContributions"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalRepositoryContributions")
          }
        }

        /// A calendar of this user's contributions on GitHub.
        public var contributionCalendar: ContributionCalendar {
          get {
            return ContributionCalendar(unsafeResultMap: resultMap["contributionCalendar"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "contributionCalendar")
          }
        }

        public struct ContributionCalendar: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ContributionCalendar"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalContributions", type: .nonNull(.scalar(Int.self))),
              GraphQLField("months", type: .nonNull(.list(.nonNull(.object(Month.selections))))),
              GraphQLField("weeks", type: .nonNull(.list(.nonNull(.object(Week.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(totalContributions: Int, months: [Month], weeks: [Week]) {
            self.init(unsafeResultMap: ["__typename": "ContributionCalendar", "totalContributions": totalContributions, "months": months.map { (value: Month) -> ResultMap in value.resultMap }, "weeks": weeks.map { (value: Week) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The count of total contributions in the calendar.
          public var totalContributions: Int {
            get {
              return resultMap["totalContributions"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "totalContributions")
            }
          }

          /// A list of the months of contributions in this calendar.
          public var months: [Month] {
            get {
              return (resultMap["months"] as! [ResultMap]).map { (value: ResultMap) -> Month in Month(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Month) -> ResultMap in value.resultMap }, forKey: "months")
            }
          }

          /// A list of the weeks of contributions in this calendar.
          public var weeks: [Week] {
            get {
              return (resultMap["weeks"] as! [ResultMap]).map { (value: ResultMap) -> Week in Week(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Week) -> ResultMap in value.resultMap }, forKey: "weeks")
            }
          }

          public struct Month: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ContributionCalendarMonth"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String) {
              self.init(unsafeResultMap: ["__typename": "ContributionCalendarMonth", "name": name])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the month.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }
          }

          public struct Week: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ContributionCalendarWeek"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("contributionDays", type: .nonNull(.list(.nonNull(.object(ContributionDay.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(contributionDays: [ContributionDay]) {
              self.init(unsafeResultMap: ["__typename": "ContributionCalendarWeek", "contributionDays": contributionDays.map { (value: ContributionDay) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The days of contributions in this week.
            public var contributionDays: [ContributionDay] {
              get {
                return (resultMap["contributionDays"] as! [ResultMap]).map { (value: ResultMap) -> ContributionDay in ContributionDay(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: ContributionDay) -> ResultMap in value.resultMap }, forKey: "contributionDays")
              }
            }

            public struct ContributionDay: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ContributionCalendarDay"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("color", type: .nonNull(.scalar(String.self))),
                  GraphQLField("contributionCount", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(color: String, contributionCount: Int) {
                self.init(unsafeResultMap: ["__typename": "ContributionCalendarDay", "color": color, "contributionCount": contributionCount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The hex color code that represents how many contributions were made on this day compared to others in the calendar.
              public var color: String {
                get {
                  return resultMap["color"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "color")
                }
              }

              /// How many contributions were made by the user on this day.
              public var contributionCount: Int {
                get {
                  return resultMap["contributionCount"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "contributionCount")
                }
              }
            }
          }
        }
      }

      public struct PinnedItem: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PinnableItemConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "PinnableItemConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Gist", "Repository"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["Repository": AsRepository.selections],
                default: [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                ]
              )
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeGist() -> Node {
            return Node(unsafeResultMap: ["__typename": "Gist"])
          }

          public static func makeRepository(name: String, nameWithOwner: String, description: String? = nil, owner: AsRepository.Owner, updatedAt: String, viewerHasStarred: Bool, primaryLanguage: AsRepository.PrimaryLanguage? = nil, stargazers: AsRepository.Stargazer) -> Node {
            return Node(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "description": description, "owner": owner.resultMap, "updatedAt": updatedAt, "viewerHasStarred": viewerHasStarred, "primaryLanguage": primaryLanguage.flatMap { (value: AsRepository.PrimaryLanguage) -> ResultMap in value.resultMap }, "stargazers": stargazers.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asRepository: AsRepository? {
            get {
              if !AsRepository.possibleTypes.contains(__typename) { return nil }
              return AsRepository(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsRepository: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Repository"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
                GraphQLField("description", type: .scalar(String.self)),
                GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
                GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
                GraphQLField("viewerHasStarred", type: .nonNull(.scalar(Bool.self))),
                GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
                GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String, nameWithOwner: String, description: String? = nil, owner: Owner, updatedAt: String, viewerHasStarred: Bool, primaryLanguage: PrimaryLanguage? = nil, stargazers: Stargazer) {
              self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "description": description, "owner": owner.resultMap, "updatedAt": updatedAt, "viewerHasStarred": viewerHasStarred, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> ResultMap in value.resultMap }, "stargazers": stargazers.resultMap])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the repository.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The repository's name with owner.
            public var nameWithOwner: String {
              get {
                return resultMap["nameWithOwner"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "nameWithOwner")
              }
            }

            /// The description of the repository.
            public var description: String? {
              get {
                return resultMap["description"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "description")
              }
            }

            /// The User owner of the repository.
            public var owner: Owner {
              get {
                return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "owner")
              }
            }

            /// Identifies the date and time when the object was last updated.
            public var updatedAt: String {
              get {
                return resultMap["updatedAt"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "updatedAt")
              }
            }

            /// Returns a boolean indicating whether the viewing user has starred this starrable.
            public var viewerHasStarred: Bool {
              get {
                return resultMap["viewerHasStarred"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "viewerHasStarred")
              }
            }

            /// The primary language of the repository's code.
            public var primaryLanguage: PrimaryLanguage? {
              get {
                return (resultMap["primaryLanguage"] as? ResultMap).flatMap { PrimaryLanguage(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "primaryLanguage")
              }
            }

            /// A list of users who have starred this starrable.
            public var stargazers: Stargazer {
              get {
                return Stargazer(unsafeResultMap: resultMap["stargazers"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "stargazers")
              }
            }

            public struct Owner: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Organization", "User"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public static func makeOrganization(avatarUrl: String) -> Owner {
                return Owner(unsafeResultMap: ["__typename": "Organization", "avatarUrl": avatarUrl])
              }

              public static func makeUser(avatarUrl: String) -> Owner {
                return Owner(unsafeResultMap: ["__typename": "User", "avatarUrl": avatarUrl])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// A URL pointing to the owner's public avatar.
              public var avatarUrl: String {
                get {
                  return resultMap["avatarUrl"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "avatarUrl")
                }
              }
            }

            public struct PrimaryLanguage: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Language"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("color", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(name: String, color: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Language", "name": name, "color": color])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The name of the current language.
              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              /// The color defined for the current language.
              public var color: String? {
                get {
                  return resultMap["color"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "color")
                }
              }
            }

            public struct Stargazer: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["StargazerConnection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(totalCount: Int) {
                self.init(unsafeResultMap: ["__typename": "StargazerConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return resultMap["totalCount"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "totalCount")
                }
              }
            }
          }
        }
      }

      public struct Organization: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OrganizationConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "OrganizationConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Organization"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("login", type: .nonNull(.scalar(String.self))),
              GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, login: String, avatarUrl: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Organization", "name": name, "login": login, "avatarUrl": avatarUrl, "description": description])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The organization's public profile name.
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// The organization's login name.
          public var login: String {
            get {
              return resultMap["login"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "login")
            }
          }

          /// A URL pointing to the organization's public avatar.
          public var avatarUrl: String {
            get {
              return resultMap["avatarUrl"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "avatarUrl")
            }
          }

          /// The organization's public profile description.
          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }
      }
    }
  }
}

public final class UserQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query User($login: String!) {
      user(login: $login) {
        __typename
        name
        login
        avatarUrl
        url
        websiteUrl
        bio
        company
        email
        location
        createdAt
        updatedAt
        viewerCanFollow
        viewerIsFollowing
        isViewer
        followers {
          __typename
          totalCount
        }
        following {
          __typename
          totalCount
        }
        starredRepositories {
          __typename
          totalCount
        }
        issues {
          __typename
          totalCount
        }
        repositories {
          __typename
          totalCount
        }
        watching {
          __typename
          totalCount
        }
        pinnedItems(first: 6) {
          __typename
          nodes {
            __typename
            ... on Repository {
              __typename
              name
              nameWithOwner
              description
              owner {
                __typename
                avatarUrl
              }
              updatedAt
              viewerHasStarred
              primaryLanguage {
                __typename
                name
                color
              }
              stargazers {
                __typename
                totalCount
              }
            }
          }
        }
        organizations(first: 10) {
          __typename
          nodes {
            __typename
            name
            login
            avatarUrl
            ... on Organization {
              __typename
              description
            }
          }
        }
        contributionsCollection {
          __typename
          contributionCalendar {
            __typename
            totalContributions
            months {
              __typename
              name
            }
            weeks {
              __typename
              contributionDays {
                __typename
                color
                contributionCount
              }
            }
          }
        }
      }
    }
    """

  public let operationName: String = "User"

  public var login: String

  public init(login: String) {
    self.login = login
  }

  public var variables: GraphQLMap? {
    return ["login": login]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("user", arguments: ["login": GraphQLVariable("login")], type: .object(User.selections)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(user: User? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "user": user.flatMap { (value: User) -> ResultMap in value.resultMap }])
    }

    /// Lookup a user by login.
    public var user: User? {
      get {
        return (resultMap["user"] as? ResultMap).flatMap { User(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "user")
      }
    }

    public struct User: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["User"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .scalar(String.self)),
          GraphQLField("login", type: .nonNull(.scalar(String.self))),
          GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
          GraphQLField("url", type: .nonNull(.scalar(String.self))),
          GraphQLField("websiteUrl", type: .scalar(String.self)),
          GraphQLField("bio", type: .scalar(String.self)),
          GraphQLField("company", type: .scalar(String.self)),
          GraphQLField("email", type: .nonNull(.scalar(String.self))),
          GraphQLField("location", type: .scalar(String.self)),
          GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("viewerCanFollow", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("viewerIsFollowing", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("isViewer", type: .nonNull(.scalar(Bool.self))),
          GraphQLField("followers", type: .nonNull(.object(Follower.selections))),
          GraphQLField("following", type: .nonNull(.object(Following.selections))),
          GraphQLField("starredRepositories", type: .nonNull(.object(StarredRepository.selections))),
          GraphQLField("issues", type: .nonNull(.object(Issue.selections))),
          GraphQLField("repositories", type: .nonNull(.object(Repository.selections))),
          GraphQLField("watching", type: .nonNull(.object(Watching.selections))),
          GraphQLField("pinnedItems", arguments: ["first": 6], type: .nonNull(.object(PinnedItem.selections))),
          GraphQLField("organizations", arguments: ["first": 10], type: .nonNull(.object(Organization.selections))),
          GraphQLField("contributionsCollection", type: .nonNull(.object(ContributionsCollection.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String? = nil, login: String, avatarUrl: String, url: String, websiteUrl: String? = nil, bio: String? = nil, company: String? = nil, email: String, location: String? = nil, createdAt: String, updatedAt: String, viewerCanFollow: Bool, viewerIsFollowing: Bool, isViewer: Bool, followers: Follower, following: Following, starredRepositories: StarredRepository, issues: Issue, repositories: Repository, watching: Watching, pinnedItems: PinnedItem, organizations: Organization, contributionsCollection: ContributionsCollection) {
        self.init(unsafeResultMap: ["__typename": "User", "name": name, "login": login, "avatarUrl": avatarUrl, "url": url, "websiteUrl": websiteUrl, "bio": bio, "company": company, "email": email, "location": location, "createdAt": createdAt, "updatedAt": updatedAt, "viewerCanFollow": viewerCanFollow, "viewerIsFollowing": viewerIsFollowing, "isViewer": isViewer, "followers": followers.resultMap, "following": following.resultMap, "starredRepositories": starredRepositories.resultMap, "issues": issues.resultMap, "repositories": repositories.resultMap, "watching": watching.resultMap, "pinnedItems": pinnedItems.resultMap, "organizations": organizations.resultMap, "contributionsCollection": contributionsCollection.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// The user's public profile name.
      public var name: String? {
        get {
          return resultMap["name"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      /// The username used to login.
      public var login: String {
        get {
          return resultMap["login"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "login")
        }
      }

      /// A URL pointing to the user's public avatar.
      public var avatarUrl: String {
        get {
          return resultMap["avatarUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "avatarUrl")
        }
      }

      /// The HTTP URL for this user
      public var url: String {
        get {
          return resultMap["url"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "url")
        }
      }

      /// A URL pointing to the user's public website/blog.
      public var websiteUrl: String? {
        get {
          return resultMap["websiteUrl"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "websiteUrl")
        }
      }

      /// The user's public profile bio.
      public var bio: String? {
        get {
          return resultMap["bio"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "bio")
        }
      }

      /// The user's public profile company.
      public var company: String? {
        get {
          return resultMap["company"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "company")
        }
      }

      /// The user's publicly visible profile email.
      public var email: String {
        get {
          return resultMap["email"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "email")
        }
      }

      /// The user's public profile location.
      public var location: String? {
        get {
          return resultMap["location"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "location")
        }
      }

      /// Identifies the date and time when the object was created.
      public var createdAt: String {
        get {
          return resultMap["createdAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "createdAt")
        }
      }

      /// Identifies the date and time when the object was last updated.
      public var updatedAt: String {
        get {
          return resultMap["updatedAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "updatedAt")
        }
      }

      /// Whether or not the viewer is able to follow the user.
      public var viewerCanFollow: Bool {
        get {
          return resultMap["viewerCanFollow"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "viewerCanFollow")
        }
      }

      /// Whether or not this user is followed by the viewer.
      public var viewerIsFollowing: Bool {
        get {
          return resultMap["viewerIsFollowing"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "viewerIsFollowing")
        }
      }

      /// Whether or not this user is the viewing user.
      public var isViewer: Bool {
        get {
          return resultMap["isViewer"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "isViewer")
        }
      }

      /// A list of users the given user is followed by.
      public var followers: Follower {
        get {
          return Follower(unsafeResultMap: resultMap["followers"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "followers")
        }
      }

      /// A list of users the given user is following.
      public var following: Following {
        get {
          return Following(unsafeResultMap: resultMap["following"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "following")
        }
      }

      /// Repositories the user has starred.
      public var starredRepositories: StarredRepository {
        get {
          return StarredRepository(unsafeResultMap: resultMap["starredRepositories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "starredRepositories")
        }
      }

      /// A list of issues associated with this user.
      public var issues: Issue {
        get {
          return Issue(unsafeResultMap: resultMap["issues"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "issues")
        }
      }

      /// A list of repositories that the user owns.
      public var repositories: Repository {
        get {
          return Repository(unsafeResultMap: resultMap["repositories"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "repositories")
        }
      }

      /// A list of repositories the given user is watching.
      public var watching: Watching {
        get {
          return Watching(unsafeResultMap: resultMap["watching"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "watching")
        }
      }

      /// A list of repositories and gists this profile owner has pinned to their profile
      public var pinnedItems: PinnedItem {
        get {
          return PinnedItem(unsafeResultMap: resultMap["pinnedItems"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "pinnedItems")
        }
      }

      /// A list of organizations the user belongs to.
      public var organizations: Organization {
        get {
          return Organization(unsafeResultMap: resultMap["organizations"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "organizations")
        }
      }

      /// The collection of contributions this user has made to different repositories.
      public var contributionsCollection: ContributionsCollection {
        get {
          return ContributionsCollection(unsafeResultMap: resultMap["contributionsCollection"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "contributionsCollection")
        }
      }

      public struct Follower: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["FollowerConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "FollowerConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Following: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["FollowingConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "FollowingConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct StarredRepository: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["StarredRepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "StarredRepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Issue: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["IssueConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "IssueConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Repository: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct Watching: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["RepositoryConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(totalCount: Int) {
          self.init(unsafeResultMap: ["__typename": "RepositoryConnection", "totalCount": totalCount])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// Identifies the total count of items in the connection.
        public var totalCount: Int {
          get {
            return resultMap["totalCount"]! as! Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "totalCount")
          }
        }
      }

      public struct PinnedItem: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["PinnableItemConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "PinnableItemConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Gist", "Repository"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLTypeCase(
                variants: ["Repository": AsRepository.selections],
                default: [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                ]
              )
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public static func makeGist() -> Node {
            return Node(unsafeResultMap: ["__typename": "Gist"])
          }

          public static func makeRepository(name: String, nameWithOwner: String, description: String? = nil, owner: AsRepository.Owner, updatedAt: String, viewerHasStarred: Bool, primaryLanguage: AsRepository.PrimaryLanguage? = nil, stargazers: AsRepository.Stargazer) -> Node {
            return Node(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "description": description, "owner": owner.resultMap, "updatedAt": updatedAt, "viewerHasStarred": viewerHasStarred, "primaryLanguage": primaryLanguage.flatMap { (value: AsRepository.PrimaryLanguage) -> ResultMap in value.resultMap }, "stargazers": stargazers.resultMap])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var asRepository: AsRepository? {
            get {
              if !AsRepository.possibleTypes.contains(__typename) { return nil }
              return AsRepository(unsafeResultMap: resultMap)
            }
            set {
              guard let newValue = newValue else { return }
              resultMap = newValue.resultMap
            }
          }

          public struct AsRepository: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["Repository"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
                GraphQLField("nameWithOwner", type: .nonNull(.scalar(String.self))),
                GraphQLField("description", type: .scalar(String.self)),
                GraphQLField("owner", type: .nonNull(.object(Owner.selections))),
                GraphQLField("updatedAt", type: .nonNull(.scalar(String.self))),
                GraphQLField("viewerHasStarred", type: .nonNull(.scalar(Bool.self))),
                GraphQLField("primaryLanguage", type: .object(PrimaryLanguage.selections)),
                GraphQLField("stargazers", type: .nonNull(.object(Stargazer.selections))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String, nameWithOwner: String, description: String? = nil, owner: Owner, updatedAt: String, viewerHasStarred: Bool, primaryLanguage: PrimaryLanguage? = nil, stargazers: Stargazer) {
              self.init(unsafeResultMap: ["__typename": "Repository", "name": name, "nameWithOwner": nameWithOwner, "description": description, "owner": owner.resultMap, "updatedAt": updatedAt, "viewerHasStarred": viewerHasStarred, "primaryLanguage": primaryLanguage.flatMap { (value: PrimaryLanguage) -> ResultMap in value.resultMap }, "stargazers": stargazers.resultMap])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the repository.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }

            /// The repository's name with owner.
            public var nameWithOwner: String {
              get {
                return resultMap["nameWithOwner"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "nameWithOwner")
              }
            }

            /// The description of the repository.
            public var description: String? {
              get {
                return resultMap["description"] as? String
              }
              set {
                resultMap.updateValue(newValue, forKey: "description")
              }
            }

            /// The User owner of the repository.
            public var owner: Owner {
              get {
                return Owner(unsafeResultMap: resultMap["owner"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "owner")
              }
            }

            /// Identifies the date and time when the object was last updated.
            public var updatedAt: String {
              get {
                return resultMap["updatedAt"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "updatedAt")
              }
            }

            /// Returns a boolean indicating whether the viewing user has starred this starrable.
            public var viewerHasStarred: Bool {
              get {
                return resultMap["viewerHasStarred"]! as! Bool
              }
              set {
                resultMap.updateValue(newValue, forKey: "viewerHasStarred")
              }
            }

            /// The primary language of the repository's code.
            public var primaryLanguage: PrimaryLanguage? {
              get {
                return (resultMap["primaryLanguage"] as? ResultMap).flatMap { PrimaryLanguage(unsafeResultMap: $0) }
              }
              set {
                resultMap.updateValue(newValue?.resultMap, forKey: "primaryLanguage")
              }
            }

            /// A list of users who have starred this starrable.
            public var stargazers: Stargazer {
              get {
                return Stargazer(unsafeResultMap: resultMap["stargazers"]! as! ResultMap)
              }
              set {
                resultMap.updateValue(newValue.resultMap, forKey: "stargazers")
              }
            }

            public struct Owner: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Organization", "User"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public static func makeOrganization(avatarUrl: String) -> Owner {
                return Owner(unsafeResultMap: ["__typename": "Organization", "avatarUrl": avatarUrl])
              }

              public static func makeUser(avatarUrl: String) -> Owner {
                return Owner(unsafeResultMap: ["__typename": "User", "avatarUrl": avatarUrl])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// A URL pointing to the owner's public avatar.
              public var avatarUrl: String {
                get {
                  return resultMap["avatarUrl"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "avatarUrl")
                }
              }
            }

            public struct PrimaryLanguage: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["Language"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("name", type: .nonNull(.scalar(String.self))),
                  GraphQLField("color", type: .scalar(String.self)),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(name: String, color: String? = nil) {
                self.init(unsafeResultMap: ["__typename": "Language", "name": name, "color": color])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The name of the current language.
              public var name: String {
                get {
                  return resultMap["name"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "name")
                }
              }

              /// The color defined for the current language.
              public var color: String? {
                get {
                  return resultMap["color"] as? String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "color")
                }
              }
            }

            public struct Stargazer: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["StargazerConnection"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("totalCount", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(totalCount: Int) {
                self.init(unsafeResultMap: ["__typename": "StargazerConnection", "totalCount": totalCount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// Identifies the total count of items in the connection.
              public var totalCount: Int {
                get {
                  return resultMap["totalCount"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "totalCount")
                }
              }
            }
          }
        }
      }

      public struct Organization: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OrganizationConnection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("nodes", type: .list(.object(Node.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(nodes: [Node?]? = nil) {
          self.init(unsafeResultMap: ["__typename": "OrganizationConnection", "nodes": nodes.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A list of nodes.
        public var nodes: [Node?]? {
          get {
            return (resultMap["nodes"] as? [ResultMap?]).flatMap { (value: [ResultMap?]) -> [Node?] in value.map { (value: ResultMap?) -> Node? in value.flatMap { (value: ResultMap) -> Node in Node(unsafeResultMap: value) } } }
          }
          set {
            resultMap.updateValue(newValue.flatMap { (value: [Node?]) -> [ResultMap?] in value.map { (value: Node?) -> ResultMap? in value.flatMap { (value: Node) -> ResultMap in value.resultMap } } }, forKey: "nodes")
          }
        }

        public struct Node: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["Organization"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("name", type: .scalar(String.self)),
              GraphQLField("login", type: .nonNull(.scalar(String.self))),
              GraphQLField("avatarUrl", type: .nonNull(.scalar(String.self))),
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("description", type: .scalar(String.self)),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(name: String? = nil, login: String, avatarUrl: String, description: String? = nil) {
            self.init(unsafeResultMap: ["__typename": "Organization", "name": name, "login": login, "avatarUrl": avatarUrl, "description": description])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The organization's public profile name.
          public var name: String? {
            get {
              return resultMap["name"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "name")
            }
          }

          /// The organization's login name.
          public var login: String {
            get {
              return resultMap["login"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "login")
            }
          }

          /// A URL pointing to the organization's public avatar.
          public var avatarUrl: String {
            get {
              return resultMap["avatarUrl"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "avatarUrl")
            }
          }

          /// The organization's public profile description.
          public var description: String? {
            get {
              return resultMap["description"] as? String
            }
            set {
              resultMap.updateValue(newValue, forKey: "description")
            }
          }
        }
      }

      public struct ContributionsCollection: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ContributionsCollection"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("contributionCalendar", type: .nonNull(.object(ContributionCalendar.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(contributionCalendar: ContributionCalendar) {
          self.init(unsafeResultMap: ["__typename": "ContributionsCollection", "contributionCalendar": contributionCalendar.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// A calendar of this user's contributions on GitHub.
        public var contributionCalendar: ContributionCalendar {
          get {
            return ContributionCalendar(unsafeResultMap: resultMap["contributionCalendar"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "contributionCalendar")
          }
        }

        public struct ContributionCalendar: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["ContributionCalendar"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLField("totalContributions", type: .nonNull(.scalar(Int.self))),
              GraphQLField("months", type: .nonNull(.list(.nonNull(.object(Month.selections))))),
              GraphQLField("weeks", type: .nonNull(.list(.nonNull(.object(Week.selections))))),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(totalContributions: Int, months: [Month], weeks: [Week]) {
            self.init(unsafeResultMap: ["__typename": "ContributionCalendar", "totalContributions": totalContributions, "months": months.map { (value: Month) -> ResultMap in value.resultMap }, "weeks": weeks.map { (value: Week) -> ResultMap in value.resultMap }])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          /// The count of total contributions in the calendar.
          public var totalContributions: Int {
            get {
              return resultMap["totalContributions"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "totalContributions")
            }
          }

          /// A list of the months of contributions in this calendar.
          public var months: [Month] {
            get {
              return (resultMap["months"] as! [ResultMap]).map { (value: ResultMap) -> Month in Month(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Month) -> ResultMap in value.resultMap }, forKey: "months")
            }
          }

          /// A list of the weeks of contributions in this calendar.
          public var weeks: [Week] {
            get {
              return (resultMap["weeks"] as! [ResultMap]).map { (value: ResultMap) -> Week in Week(unsafeResultMap: value) }
            }
            set {
              resultMap.updateValue(newValue.map { (value: Week) -> ResultMap in value.resultMap }, forKey: "weeks")
            }
          }

          public struct Month: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ContributionCalendarMonth"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("name", type: .nonNull(.scalar(String.self))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(name: String) {
              self.init(unsafeResultMap: ["__typename": "ContributionCalendarMonth", "name": name])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The name of the month.
            public var name: String {
              get {
                return resultMap["name"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "name")
              }
            }
          }

          public struct Week: GraphQLSelectionSet {
            public static let possibleTypes: [String] = ["ContributionCalendarWeek"]

            public static var selections: [GraphQLSelection] {
              return [
                GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                GraphQLField("contributionDays", type: .nonNull(.list(.nonNull(.object(ContributionDay.selections))))),
              ]
            }

            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public init(contributionDays: [ContributionDay]) {
              self.init(unsafeResultMap: ["__typename": "ContributionCalendarWeek", "contributionDays": contributionDays.map { (value: ContributionDay) -> ResultMap in value.resultMap }])
            }

            public var __typename: String {
              get {
                return resultMap["__typename"]! as! String
              }
              set {
                resultMap.updateValue(newValue, forKey: "__typename")
              }
            }

            /// The days of contributions in this week.
            public var contributionDays: [ContributionDay] {
              get {
                return (resultMap["contributionDays"] as! [ResultMap]).map { (value: ResultMap) -> ContributionDay in ContributionDay(unsafeResultMap: value) }
              }
              set {
                resultMap.updateValue(newValue.map { (value: ContributionDay) -> ResultMap in value.resultMap }, forKey: "contributionDays")
              }
            }

            public struct ContributionDay: GraphQLSelectionSet {
              public static let possibleTypes: [String] = ["ContributionCalendarDay"]

              public static var selections: [GraphQLSelection] {
                return [
                  GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
                  GraphQLField("color", type: .nonNull(.scalar(String.self))),
                  GraphQLField("contributionCount", type: .nonNull(.scalar(Int.self))),
                ]
              }

              public private(set) var resultMap: ResultMap

              public init(unsafeResultMap: ResultMap) {
                self.resultMap = unsafeResultMap
              }

              public init(color: String, contributionCount: Int) {
                self.init(unsafeResultMap: ["__typename": "ContributionCalendarDay", "color": color, "contributionCount": contributionCount])
              }

              public var __typename: String {
                get {
                  return resultMap["__typename"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "__typename")
                }
              }

              /// The hex color code that represents how many contributions were made on this day compared to others in the calendar.
              public var color: String {
                get {
                  return resultMap["color"]! as! String
                }
                set {
                  resultMap.updateValue(newValue, forKey: "color")
                }
              }

              /// How many contributions were made by the user on this day.
              public var contributionCount: Int {
                get {
                  return resultMap["contributionCount"]! as! Int
                }
                set {
                  resultMap.updateValue(newValue, forKey: "contributionCount")
                }
              }
            }
          }
        }
      }
    }
  }
}
