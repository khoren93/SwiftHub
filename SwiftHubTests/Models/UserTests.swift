//
//  UserTests.swift
//  SwiftHubTests
//
//  Created by Sygnoos9 on 2/5/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftHub

class UserTests: QuickSpec {

    override func spec() {

        let login = "khoren93"
        let name = "Khoren Markosyan"
        let type = "User"
        let createdAt = "2015-03-17T15:14:24Z"
        let htmlUrl = "https://github.com/khoren93"
        let avatarUrl = "https://avatars2.githubusercontent.com/u/11523360?v=4"

        describe("converts from JSON") {
            it("User") {
                let data: [String: Any] = ["login": login, "name": name, "type": type, "created_at": createdAt, "html_url": htmlUrl, "avatar_url": avatarUrl]
                let user = User(JSON: data)

                expect(user?.login) == login
                expect(user?.name) == name
                expect(user?.type) == UserType(rawValue: type)
                expect(user?.createdAt) == createdAt.toISODate()?.date
                expect(user?.htmlUrl) == htmlUrl
                expect(user?.avatarUrl) == avatarUrl
            }

            it("TrendingUser") {
                let data: [String: Any] = ["username": login, "name": name, "url": htmlUrl, "avatar": avatarUrl]
                let user = TrendingUser(JSON: data)

                expect(user?.username) == login
                expect(user?.name) == name
                expect(user?.url) == htmlUrl
                expect(user?.avatar) == avatarUrl
            }
        }

        describe("user lifecycle") {
            it("save and remove user") {
                let data: [String: Any] = ["login": login, "name": name, "type": type, "created_at": createdAt, "html_url": htmlUrl, "avatar_url": avatarUrl]
                let user = User(JSON: data)

                User.removeCurrentUser()
                expect(user?.isMine()) == false

                user?.save()
                expect(user?.isMine()) == true
            }
        }
    }
}
