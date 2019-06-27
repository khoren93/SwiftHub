//
//  UsersViewModelTests.swift
//  SwiftHubTests
//
//  Created by Khoren Markosyan on 2/8/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Quick
import Nimble
import RxSwift
@testable import SwiftHub

class UsersViewModelTests: QuickSpec {

    override func spec() {
        var viewModel: UsersViewModel!
        var provider: SwiftHubAPI!  // used stubbing responses
        var disposeBag: DisposeBag!

        beforeEach {
            provider = RestApi(githubProvider: GithubNetworking.stubbingGithubNetworking(),
                               trendingGithubProvider: TrendingGithubNetworking.stubbingTrendingGithubNetworking())
            disposeBag = DisposeBag()
        }

        afterEach {
            viewModel = nil // Force viewModel to deallocate and stop syncing.
        }

        describe("users list from repository") {
            it("stargazers") {
                viewModel = UsersViewModel(mode: .stars(repository: Repository()), provider: provider)
                let title = R.string.localizable.usersStargazersNavigationTitle.key.localized()
                self.testViewModel(viewModel: viewModel, title: title, itemsPerPage: 3, disposeBag: disposeBag)
            }

            it("watchers") {
                viewModel = UsersViewModel(mode: .watchers(repository: Repository()), provider: provider)
                let title = R.string.localizable.usersWatchersNavigationTitle.key.localized()
                self.testViewModel(viewModel: viewModel, title: title, itemsPerPage: 3, disposeBag: disposeBag)
            }

            it("contributors") {
                viewModel = UsersViewModel(mode: .contributors(repository: Repository()), provider: provider)
                let title = R.string.localizable.usersContributorsNavigationTitle.key.localized()
                self.testViewModel(viewModel: viewModel, title: title, itemsPerPage: 2, disposeBag: disposeBag)
            }
        }

        describe("users list from profile") {
            it("followers") {
                viewModel = UsersViewModel(mode: .followers(user: User()), provider: provider)
                let title = R.string.localizable.usersFollowersNavigationTitle.key.localized()
                self.testViewModel(viewModel: viewModel, title: title, itemsPerPage: 3, disposeBag: disposeBag)
            }

            it("following") {
                viewModel = UsersViewModel(mode: .following(user: User()), provider: provider)
                let title = R.string.localizable.usersFollowingNavigationTitle.key.localized()
                self.testViewModel(viewModel: viewModel, title: title, itemsPerPage: 3, disposeBag: disposeBag)
            }
        }
    }

    func testViewModel(viewModel: UsersViewModel, title: String, itemsPerPage: Int, disposeBag: DisposeBag) {
        let headerRefresh = PublishSubject<Void>()
        let footerRefresh = PublishSubject<Void>()
        let keywordTrigger = PublishSubject<String>()
        let textDidBeginEditing = PublishSubject<Void>()
        let selection = PublishSubject<UserCellViewModel>()

        let input = UsersViewModel.Input(headerRefresh: headerRefresh,
                                         footerRefresh: footerRefresh,
                                         keywordTrigger: keywordTrigger.asDriver(onErrorJustReturn: ""),
                                         textDidBeginEditing: textDidBeginEditing.asDriver(onErrorJustReturn: ()),
                                         selection: selection.asDriver(onErrorJustReturn: UserCellViewModel(with: User())))
        let output = viewModel.transform(input: input)

        output.navigationTitle.drive(onNext: { (navigationTitle) in
            expect(navigationTitle) == title
        }).disposed(by: disposeBag)

        // test pagination
        expect(output.items.value.count) == 0
        expect(viewModel.page) == 1
        headerRefresh.onNext(())
        expect(output.items.value.count) == itemsPerPage * viewModel.page
        expect(viewModel.page) == 1
        footerRefresh.onNext(())
        expect(output.items.value.count) == itemsPerPage * viewModel.page
        expect(viewModel.page) == 2

        // test selection
        let selectedUser = output.items.value.first
        output.userSelected.drive(onNext: { (viewModel) in
            expect(viewModel.user.value) == selectedUser?.user
        }).disposed(by: disposeBag)
        if let user = selectedUser {
            selection.onNext(user)
        }
    }
}
