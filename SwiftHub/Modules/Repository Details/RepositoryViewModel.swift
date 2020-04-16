//
//  RepositoryViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RepositoryViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let imageSelection: Observable<Void>
        let openInWebSelection: Observable<Void>
        let watchersSelection: Observable<Void>
        let starsSelection: Observable<Void>
        let forksSelection: Observable<Void>
        let selection: Driver<RepositorySectionItem>
        let starSelection: Observable<Void>
    }

    struct Output {
        let items: Observable<[RepositorySection]>
        let name: Driver<String>
        let description: Driver<String>
        let imageUrl: Driver<URL?>
        let starring: Driver<Bool>
        let hidesStarButton: Driver<Bool>
        let watchersCount: Driver<Int>
        let starsCount: Driver<Int>
        let forksCount: Driver<Int>
        let imageSelected: Driver<UserViewModel>
        let openInWebSelected: Driver<URL>
        let repositoriesSelected: Driver<RepositoriesViewModel>
        let usersSelected: Driver<UsersViewModel>
        let selectedEvent: Driver<RepositorySectionItem>
    }

    let repository: BehaviorRelay<Repository>
    let readme = BehaviorRelay<Content?>(value: nil)
    let selectedBranch = BehaviorRelay<String?>(value: nil)

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
        if let fullname = repository.fullname {
            analytics.log(.repository(fullname: fullname))
        }
    }

    func transform(input: Input) -> Output {

        let refreshRepository = Observable.combineLatest(input.headerRefresh, selectedBranch)
        refreshRepository.flatMapLatest { [weak self] (_, branch) -> Observable<Repository> in
            guard let self = self else { return Observable.just(Repository()) }
            let fullname = self.repository.value.fullname ?? ""
            let qualifiedName = branch ?? self.repository.value.defaultBranch
            return self.provider.repository(fullname: fullname, qualifiedName: qualifiedName)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (repository) in
                self?.repository.accept(repository)
            }).disposed(by: rx.disposeBag)

        input.headerRefresh.flatMapLatest { [weak self] () -> Observable<Content> in
            guard let self = self else { return Observable.just(Content()) }
            let fullname = self.repository.value.fullname ?? ""
            return self.provider.readme(fullname: fullname, ref: nil)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
            }.subscribe(onNext: { [weak self] (content) in
                self?.readme.accept(content)
            }).disposed(by: rx.disposeBag)

        let starred = input.starSelection.flatMapLatest { [weak self] () -> Observable<RxSwift.Event<Void>> in
            guard let self = self, loggedIn.value == true else { return Observable.just(RxSwift.Event.next(())) }
            let fullname = self.repository.value.fullname ?? ""
            let starring = self.repository.value.viewerHasStarred
            let request = starring == true ? self.provider.unstarRepository(fullname: fullname) : self.provider.starRepository(fullname: fullname)
            return request
                .trackActivity(self.loading)
                .materialize()
                .share()
            }

        starred.subscribe(onNext: { (event) in
            switch event {
            case .next: logDebug("Starred success")
            case .error(let error): logError("\(error.localizedDescription)")
            case .completed: break
            }
        }).disposed(by: rx.disposeBag)

        let refreshStarring = Observable.of(input.headerRefresh, starred.mapToVoid()).merge()
        refreshStarring.flatMapLatest { [weak self] () -> Observable<RxSwift.Event<Void>> in
            guard let self = self, loggedIn.value == true else { return Observable.just(RxSwift.Event.next(())) }
            let fullname = self.repository.value.fullname ?? ""
            return self.provider.checkStarring(fullname: fullname)
                .trackActivity(self.loading)
                .materialize()
                .share()
            }.subscribe(onNext: { [weak self] (event) in
                guard let self = self else { return }
                switch event {
                case .next:
                    var repository = self.repository.value
                    repository.viewerHasStarred = true
                    self.repository.accept(repository)
                case .error:
                    var repository = self.repository.value
                    repository.viewerHasStarred = false
                    self.repository.accept(repository)
                case .completed: break
                }
            }).disposed(by: rx.disposeBag)

        let name = repository.map { $0.fullname ?? "" }.asDriverOnErrorJustComplete()
        let description = repository.map { $0.descriptionField ?? "" }.asDriverOnErrorJustComplete()
        let watchersCount = repository.map { $0.subscribersCount ?? 0 }.asDriverOnErrorJustComplete()
        let starsCount = repository.map { $0.stargazersCount ?? 0 }.asDriverOnErrorJustComplete()
        let forksCount = repository.map { $0.forks ?? 0 }.asDriverOnErrorJustComplete()
        let imageUrl = repository.map { $0.owner?.avatarUrl?.url }.asDriverOnErrorJustComplete()
        let hidesStarButton = loggedIn.map { !$0 }.asDriver(onErrorJustReturn: false)

        let imageSelected = input.imageSelection.asDriver(onErrorJustReturn: ())
            .map { () -> UserViewModel in
                let user = self.repository.value.owner ?? User()
                let viewModel = UserViewModel(user: user, provider: self.provider)
                return viewModel
        }

        let openInWebSelected = input.openInWebSelection.map { () -> URL? in
            self.repository.value.htmlUrl?.url
        }.asDriver(onErrorJustReturn: nil).filterNil()

        let repositoriesSelected = input.forksSelection.asDriver(onErrorJustReturn: ())
            .map { () -> RepositoriesViewModel in
                let mode = RepositoriesMode.forks(repository: self.repository.value)
                let viewModel = RepositoriesViewModel(mode: mode, provider: self.provider)
                return viewModel
        }

        let watchersSelected = input.watchersSelection.map { UsersMode.watchers(repository: self.repository.value) }
        let starsSelected = input.starsSelection.map { UsersMode.stars(repository: self.repository.value) }

        let usersSelected = Observable.of(watchersSelected, starsSelected).merge()
            .asDriver(onErrorJustReturn: .followers(user: User()))
            .map { (mode) -> UsersViewModel in
                let viewModel = UsersViewModel(mode: mode, provider: self.provider)
                return viewModel
        }

        let starring = repository.map { $0.viewerHasStarred }.filterNil()

        let items = repository.map { (repository) -> [RepositorySection] in
            var items: [RepositorySectionItem] = []

            // Parent
            if let parentName = repository.parentFullname {
                let parentCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryParentCellTitle.key.localized(),
                                                                        detail: parentName,
                                                                        image: R.image.icon_cell_git_fork()?.template,
                                                                        hidesDisclosure: false)
                items.append(RepositorySectionItem.parentItem(viewModel: parentCellViewModel))
            }

            if let languages = repository.languages {
                // Languages available only for OAuth authentication
                let languagesCellViewModel = LanguagesCellViewModel(languages: languages)
                items.append(RepositorySectionItem.languagesItem(viewModel: languagesCellViewModel))
            } else if let language = repository.language {
                // Language
                let languageCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryLanguageCellTitle.key.localized(),
                                                                          detail: language,
                                                                          image: R.image.icon_cell_git_language()?.template,
                                                                          hidesDisclosure: true)
                items.append(RepositorySectionItem.languageItem(viewModel: languageCellViewModel))
            }

            // Size
            if let size = repository.size {
                let sizeCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositorySizeCellTitle.key.localized(),
                                                                      detail: size.sizeFromKB(),
                                                                      image: R.image.icon_cell_size()?.template,
                                                                      hidesDisclosure: true)
                items.append(RepositorySectionItem.sizeItem(viewModel: sizeCellViewModel))
            }

            // Created
            if let created = repository.createdAt {
                let createdCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryCreatedCellTitle.key.localized(),
                                                                         detail: created.toRelative(),
                                                                         image: R.image.icon_cell_created()?.template,
                                                                         hidesDisclosure: true)
                items.append(RepositorySectionItem.createdItem(viewModel: createdCellViewModel))
            }

            // Updated
            if let updated = repository.updatedAt {
                let updatedCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryUpdatedCellTitle.key.localized(),
                                                                         detail: updated.toRelative(),
                                                                         image: R.image.icon_cell_updated()?.template,
                                                                         hidesDisclosure: true)
                items.append(RepositorySectionItem.updatedItem(viewModel: updatedCellViewModel))
            }

            // Homepage
            if let homepage = repository.homepage, homepage.isNotEmpty {
                let homepageCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryHomepageCellTitle.key.localized(),
                                                                         detail: homepage,
                                                                         image: R.image.icon_cell_link()?.template,
                                                                         hidesDisclosure: false)
                items.append(RepositorySectionItem.homepageItem(viewModel: homepageCellViewModel))
            }

            // Issues
            let issuesCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryIssuesCellTitle.key.localized(),
                                                                    detail: repository.openIssuesCount?.string ?? "",
                                                                    image: R.image.icon_cell_issues()?.template,
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.issuesItem(viewModel: issuesCellViewModel))

            // Pull Requests
            let pullRequestsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryPullRequestsCellTitle.key.localized(),
                                                                          detail: repository.pullRequestsCount?.string ?? "",
                                                                          image: R.image.icon_cell_git_pull_request()?.template,
                                                                          hidesDisclosure: false)
            items.append(RepositorySectionItem.pullRequestsItem(viewModel: pullRequestsCellViewModel))

            // Commits
            let commitsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryCommitsCellTitle.key.localized(),
                                                                     detail: repository.commitsCount?.string ?? "",
                                                                     image: R.image.icon_cell_git_commit()?.template,
                                                                     hidesDisclosure: false)
            items.append(RepositorySectionItem.commitsItem(viewModel: commitsCellViewModel))

            // Branches
            let branchesCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryBranchesCellTitle.key.localized(),
                                                                      detail: self.selectedBranch.value ?? repository.defaultBranch,
                                                                      image: R.image.icon_cell_git_branch()?.template,
                                                                      hidesDisclosure: false)
            items.append(RepositorySectionItem.branchesItem(viewModel: branchesCellViewModel))

            // Releases
            let releasesCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryReleasesCellTitle.key.localized(),
                                                                      detail: repository.releasesCount?.string ?? "",
                                                                      image: R.image.icon_cell_releases()?.template,
                                                                      hidesDisclosure: false)
            items.append(RepositorySectionItem.releasesItem(viewModel: releasesCellViewModel))

            // Contributors
            let contributorsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryContributorsCellTitle.key.localized(),
                                                                          detail: repository.contributorsCount?.string ?? "",
                                                                          image: R.image.icon_cell_company()?.template,
                                                                          hidesDisclosure: false)
            items.append(RepositorySectionItem.contributorsItem(viewModel: contributorsCellViewModel))

            // Events
            let eventsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryEventsCellTitle.key.localized(),
                                                                    detail: "",
                                                                    image: R.image.icon_cell_events()?.template,
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.eventsItem(viewModel: eventsCellViewModel))

            if loggedIn.value {
                // Notifications
                let notificationsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryNotificationsCellTitle.key.localized(),
                                                                               detail: "",
                                                                               image: R.image.icon_tabbar_activity()?.template,
                                                                               hidesDisclosure: false)
                items.append(RepositorySectionItem.notificationsItem(viewModel: notificationsCellViewModel))
            }

            // Source
            let sourceCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositorySourceCellTitle.key.localized(),
                                                                    detail: "",
                                                                    image: R.image.icon_cell_source()?.template,
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.sourceItem(viewModel: sourceCellViewModel))

            // Stars history
            let starHistoryCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryStarsHistoryCellTitle.key.localized(),
                                                                         detail: Configs.Network.starHistoryBaseUrl,
                                                                         image: R.image.icon_cell_stars_history()?.template,
                                                                         hidesDisclosure: false)
            items.append(RepositorySectionItem.starHistoryItem(viewModel: starHistoryCellViewModel))

            // Count lines of code
            let clocCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryCountLinesOfCodeCellTitle.key.localized(),
                                                                         detail: "",
                                                                         image: R.image.icon_cell_cloc()?.template,
                                                                         hidesDisclosure: false)
            items.append(RepositorySectionItem.countLinesOfCodeItem(viewModel: clocCellViewModel))

            return [
                RepositorySection.repository(title: "", items: items)
            ]
        }

        let selectedEvent = input.selection

        return Output(items: items,
                      name: name,
                      description: description,
                      imageUrl: imageUrl,
                      starring: starring.asDriver(onErrorJustReturn: false),
                      hidesStarButton: hidesStarButton,
                      watchersCount: watchersCount,
                      starsCount: starsCount,
                      forksCount: forksCount,
                      imageSelected: imageSelected,
                      openInWebSelected: openInWebSelected,
                      repositoriesSelected: repositoriesSelected,
                      usersSelected: usersSelected,
                      selectedEvent: selectedEvent)
    }

    func viewModel(for item: RepositorySectionItem) -> ViewModel? {
        switch item {
        case .parentItem:
            if let parentRepository = repository.value.parentRepository() {
                let viewModel = RepositoryViewModel(repository: parentRepository, provider: provider)
                return viewModel
            }

        case .issuesItem:
            let viewModel = IssuesViewModel(repository: repository.value, provider: provider)
            return viewModel

        case .commitsItem:
            let viewModel = CommitsViewModel(repository: repository.value, provider: provider)
            return viewModel

        case .branchesItem:
            let viewModel = BranchesViewModel(repository: repository.value, provider: provider)
            viewModel.branchSelected.map { $0.name }.bind(to: selectedBranch).disposed(by: rx.disposeBag)
            return viewModel

        case .releasesItem:
            let viewModel = ReleasesViewModel(repository: repository.value, provider: provider)
            return viewModel

        case .pullRequestsItem:
            let viewModel = PullRequestsViewModel(repository: repository.value, provider: provider)
            return viewModel

        case .eventsItem:
            let mode = EventsMode.repository(repository: repository.value)
            let viewModel = EventsViewModel(mode: mode, provider: provider)
            return viewModel

        case .notificationsItem:
            let mode = NotificationsMode.repository(repository: repository.value)
            let viewModel = NotificationsViewModel(mode: mode, provider: provider)
            return viewModel

        case .contributorsItem:
            let mode = UsersMode.contributors(repository: repository.value)
            let viewModel = UsersViewModel(mode: mode, provider: provider)
            return viewModel

        case .sourceItem:
            let ref = repository.value.defaultBranch
            let viewModel = ContentsViewModel(repository: repository.value, content: nil, ref: ref, provider: provider)
            return viewModel

        case .countLinesOfCodeItem:
            let viewModel = LinesCountViewModel(repository: repository.value, provider: provider)
            return viewModel

        default: return nil
        }
        return nil
    }

    func starHistoryUrl() -> URL? {
        return "\(Configs.Network.starHistoryBaseUrl)/#\(self.repository.value.fullname ?? "")".url
    }
}
