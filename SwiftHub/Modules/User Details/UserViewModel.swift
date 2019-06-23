//
//  UserViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class UserViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let imageSelection: Observable<Void>
        let openInWebSelection: Observable<Void>
        let repositoriesSelection: Observable<Void>
        let followersSelection: Observable<Void>
        let followingSelection: Observable<Void>
        let selection: Driver<UserSectionItem>
        let followSelection: Observable<Void>
    }

    struct Output {
        let items: Observable<[UserSection]>
        let username: Driver<String>
        let fullname: Driver<String>
        let description: Driver<String>
        let imageUrl: Driver<URL?>
        let following: Driver<Bool>
        let hidesFollowButton: Driver<Bool>
        let repositoriesCount: Driver<Int>
        let followersCount: Driver<Int>
        let followingCount: Driver<Int>
        let imageSelected: Driver<Void>
        let openInWebSelected: Driver<URL?>
        let repositoriesSelected: Driver<RepositoriesViewModel>
        let usersSelected: Driver<UsersViewModel>
        let selectedEvent: Driver<UserSectionItem>
    }

    let user: BehaviorRelay<User>

    init(user: User, provider: SwiftHubAPI) {
        self.user = BehaviorRelay(value: user)
        super.init(provider: provider)
        if let login = user.login {
            analytics.log(.user(login: login))
        }
    }

    func transform(input: Input) -> Output {

        input.headerRefresh.flatMapLatest { [weak self] () -> Observable<User> in
            guard let self = self else { return Observable.just(User()) }
            let user = self.user.value
            let request: Single<User>
            if !user.isMine() {
                let owner = user.login ?? ""
                switch user.type {
                case .user: request = self.provider.user(owner: owner)
                case .organization: request = self.provider.organization(owner: owner)
                }
            } else {
                request = self.provider.profile()
            }
            return request
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (user) in
                self?.user.accept(user)
                if user.isMine() {
                    user.save()
                }
            }).disposed(by: rx.disposeBag)

        let followed = input.followSelection.flatMapLatest { [weak self] () -> Observable<RxSwift.Event<Void>> in
            guard let self = self, loggedIn.value == true else { return Observable.just(RxSwift.Event.next(())) }
            let username = self.user.value.login ?? ""
            let following = self.user.value.viewerIsFollowing
            let request = following == true ? self.provider.unfollowUser(username: username) : self.provider.followUser(username: username)
            return request
                .trackActivity(self.loading)
                .materialize()
                .share()
        }

        followed.subscribe(onNext: { (event) in
            switch event {
            case .next: logDebug("Followed success")
            case .error(let error): logError("\(error.localizedDescription)")
            case .completed: break
            }
        }).disposed(by: rx.disposeBag)

        let refreshStarring = Observable.of(input.headerRefresh, followed.mapToVoid()).merge()
        refreshStarring.flatMapLatest { [weak self] () -> Observable<RxSwift.Event<Void>> in
            guard let self = self, loggedIn.value == true else { return Observable.just(RxSwift.Event.next(())) }
            let username = self.user.value.login ?? ""
            return self.provider.checkFollowing(username: username)
                .trackActivity(self.loading)
                .materialize()
                .share()
            }.subscribe(onNext: { [weak self] (event) in
                guard let self = self else { return }
                switch event {
                case .next:
                    var user = self.user.value
                    user.viewerIsFollowing = true
                    self.user.accept(user)
                case .error:
                    var user = self.user.value
                    user.viewerIsFollowing = false
                    self.user.accept(user)
                case .completed: break
            }
        }).disposed(by: rx.disposeBag)

        let username = user.map { $0.login ?? "" }.asDriverOnErrorJustComplete()
        let fullname = user.map { $0.name ?? "" }.asDriverOnErrorJustComplete()
        let description = user.map { $0.bio ?? $0.descriptionField ?? "" }.asDriverOnErrorJustComplete()
        let imageUrl = user.map { $0.avatarUrl?.url }.asDriverOnErrorJustComplete()
        let repositoriesCount = user.map { $0.repositoriesCount ?? 0 }.asDriverOnErrorJustComplete()
        let followersCount = user.map { $0.followers ?? 0 }.asDriverOnErrorJustComplete()
        let followingCount = user.map { $0.following ?? 0 }.asDriverOnErrorJustComplete()
        let imageSelected = input.imageSelection.asDriverOnErrorJustComplete()
        let openInWebSelected = input.openInWebSelection.map { () -> URL? in
            self.user.value.htmlUrl?.url
        }.asDriver(onErrorJustReturn: nil)

        let hidesFollowButton = Observable.combineLatest(loggedIn, user).map({ (loggedIn, user) -> Bool in
            guard loggedIn == true else { return true }
            return user.isMine() == true || user.type == .organization
        }).asDriver(onErrorJustReturn: false)

        let repositoriesSelected = input.repositoriesSelection.asDriver(onErrorJustReturn: ())
            .map { () -> RepositoriesViewModel in
                let mode = RepositoriesMode.userRepositories(user: self.user.value)
                let viewModel = RepositoriesViewModel(mode: mode, provider: self.provider)
                return viewModel
        }

        let followersSelected = input.followersSelection.map { UsersMode.followers(user: self.user.value) }
        let followingSelected = input.followingSelection.map { UsersMode.following(user: self.user.value) }

        let usersSelected = Observable.of(followersSelected, followingSelected).merge()
            .asDriver(onErrorJustReturn: .followers(user: User()))
            .map { (mode) -> UsersViewModel in
                let viewModel = UsersViewModel(mode: mode, provider: self.provider)
                return viewModel
        }

        let following = user.map { $0.viewerIsFollowing }.filterNil()

        let items = user.map { (user) -> [UserSection] in
            var items: [UserSectionItem] = []

            // Created
            if let created = user.createdAt {
                let createdCellViewModel = UserDetailCellViewModel(with: R.string.localizable.repositoryCreatedCellTitle.key.localized(),
                                                                   detail: created.toRelative(),
                                                                   image: R.image.icon_cell_created()?.template,
                                                                   hidesDisclosure: true)
                items.append(UserSectionItem.createdItem(viewModel: createdCellViewModel))
            }

            // Updated
            if let updated = user.updatedAt {
                let updatedCellViewModel = UserDetailCellViewModel(with: R.string.localizable.repositoryUpdatedCellTitle.key.localized(),
                                                                   detail: updated.toRelative(),
                                                                   image: R.image.icon_cell_updated()?.template,
                                                                   hidesDisclosure: true)
                items.append(UserSectionItem.updatedItem(viewModel: updatedCellViewModel))
            }

            if user.type == .user {
                // Stars
                let starsCellViewModel = UserDetailCellViewModel(with: R.string.localizable.userStarsCellTitle.key.localized(),
                                                                 detail: user.starredRepositoriesCount?.string ?? "",
                                                                 image: R.image.icon_cell_star()?.template,
                                                                 hidesDisclosure: false)
                items.append(UserSectionItem.starsItem(viewModel: starsCellViewModel))

                // Watching
                let watchingCellViewModel = UserDetailCellViewModel(with: R.string.localizable.userWatchingCellTitle.key.localized(),
                                                                    detail: user.watchingCount?.string ?? "",
                                                                    image: R.image.icon_cell_theme()?.template,
                                                                    hidesDisclosure: false)
                items.append(UserSectionItem.watchingItem(viewModel: watchingCellViewModel))
            }

            // Events
            let eventsCellViewModel = UserDetailCellViewModel(with: R.string.localizable.userEventsCellTitle.key.localized(),
                                                              detail: "",
                                                              image: R.image.icon_cell_events()?.template,
                                                              hidesDisclosure: false)
            items.append(UserSectionItem.eventsItem(viewModel: eventsCellViewModel))

            // Company
            if let company = user.company, company.isNotEmpty {
                let companyCellViewModel = UserDetailCellViewModel(with: R.string.localizable.userCompanyCellTitle.key.localized(),
                                                                   detail: company,
                                                                   image: R.image.icon_cell_company()?.template,
                                                                   hidesDisclosure: false)
                items.append(UserSectionItem.companyItem(viewModel: companyCellViewModel))
            }

            // Blog
            if let blog = user.blog, blog.isNotEmpty {
                let companyCellViewModel = UserDetailCellViewModel(with: R.string.localizable.userBlogCellTitle.key.localized(),
                                                                   detail: blog,
                                                                   image: R.image.icon_cell_link()?.template,
                                                                   hidesDisclosure: false)
                items.append(UserSectionItem.blogItem(viewModel: companyCellViewModel))
            }

            // Profile Summary
            let profileSummaryCellViewModel = UserDetailCellViewModel(with: R.string.localizable.userProfileSummaryCellTitle.key.localized(),
                                                                      detail: "\(Configs.Network.profileSummaryBaseUrl)",
                                                                      image: R.image.icon_cell_profile_summary()?.template,
                                                                      hidesDisclosure: false)
            items.append(UserSectionItem.profileSummaryItem(viewModel: profileSummaryCellViewModel))

            // Pinned Repositories
            var pinnedItems: [UserSectionItem] = []
            if let repos = user.pinnedRepositories?.map({ RepositoryCellViewModel(with: $0) }) {
                repos.forEach({ (cellViewModel) in
                    pinnedItems.append(UserSectionItem.repositoryItem(viewModel: cellViewModel))
                })
            }

            // User Organizations
            var organizationItems: [UserSectionItem] = []
            if let repos = user.organizations?.map({ UserCellViewModel(with: $0) }) {
                repos.forEach({ (cellViewModel) in
                    organizationItems.append(UserSectionItem.organizationItem(viewModel: cellViewModel))
                })
            }

            var userSections: [UserSection] = []
            userSections.append(UserSection.user(title: "", items: items))
            if pinnedItems.isNotEmpty {
                userSections.append(UserSection.user(title: R.string.localizable.userPinnedSectionTitle.key.localized(), items: pinnedItems))
            }
            if organizationItems.isNotEmpty {
                userSections.append(UserSection.user(title: R.string.localizable.userOrganizationsSectionTitle.key.localized(), items: organizationItems))
            }
            return userSections
        }

        let selectedEvent = input.selection

        return Output(items: items,
                      username: username,
                      fullname: fullname,
                      description: description,
                      imageUrl: imageUrl,
                      following: following.asDriver(onErrorJustReturn: false),
                      hidesFollowButton: hidesFollowButton,
                      repositoriesCount: repositoriesCount,
                      followersCount: followersCount,
                      followingCount: followingCount,
                      imageSelected: imageSelected,
                      openInWebSelected: openInWebSelected,
                      repositoriesSelected: repositoriesSelected,
                      usersSelected: usersSelected,
                      selectedEvent: selectedEvent)
    }

    func viewModel(for item: UserSectionItem) -> ViewModel? {
        let user = self.user.value
        switch item {
        case .createdItem: return nil
        case .updatedItem: return nil
        case .starsItem:
            let mode = RepositoriesMode.userStarredRepositories(user: user)
            let viewModel = RepositoriesViewModel(mode: mode, provider: provider)
            return viewModel

        case .watchingItem:
            let mode = RepositoriesMode.userWatchingRepositories(user: user)
            let viewModel = RepositoriesViewModel(mode: mode, provider: provider)
            return viewModel
        case .eventsItem:
            let mode = EventsMode.user(user: user)
            let viewModel = EventsViewModel(mode: mode, provider: provider)
            return viewModel
        case .companyItem:
            if let companyName = user.company?.removingPrefix("@") {
                var user = User()
                user.login = companyName
                let viewModel = UserViewModel(user: user, provider: provider)
                return viewModel
            }
        case .blogItem: return nil
        case .profileSummaryItem: return nil
        case .repositoryItem(let cellViewModel):
            let viewModel = RepositoryViewModel(repository: cellViewModel.repository, provider: provider)
            return viewModel
        case .organizationItem(let cellViewModel):
            let viewModel = UserViewModel(user: cellViewModel.user, provider: provider)
            return viewModel
        }
        return nil
    }

    func profileSummaryUrl() -> URL? {
        return "\(Configs.Network.profileSummaryBaseUrl)/user/\(self.user.value.login ?? "")".url
    }
}
