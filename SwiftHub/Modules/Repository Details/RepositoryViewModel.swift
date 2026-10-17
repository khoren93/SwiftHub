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

        starred.subscribe(onNext: { [weak self] (event) in
            switch event {
            case .next:
                let fullname = self?.repository.value.fullname ?? ""
                analytics.log(.repositoryStar(fullname: fullname))
                logDebug("Starred success")
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
                let parentCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryParentCellTitle),
                                                                        detail: parentName,
                                                                        image: UIImage(resource: .iconCellGitFork).template,
                                                                        hidesDisclosure: false)
                items.append(RepositorySectionItem.parentItem(viewModel: parentCellViewModel))
            }

            if let languages = repository.languages {
                // Languages available only for OAuth authentication
                let languagesCellViewModel = LanguagesCellViewModel(languages: languages)
                items.append(RepositorySectionItem.languagesItem(viewModel: languagesCellViewModel))
            } else if let language = repository.language {
                // Language
                let languageCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryLanguageCellTitle),
                                                                          detail: language,
                                                                          image: UIImage(resource: .iconCellGitLanguage).template,
                                                                          hidesDisclosure: true)
                items.append(RepositorySectionItem.languageItem(viewModel: languageCellViewModel))
            }

            // Size
            if let size = repository.size {
                let sizeCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositorySizeCellTitle),
                                                                      detail: size.sizeFromKB(),
                                                                      image: UIImage(resource: .iconCellSize).template,
                                                                      hidesDisclosure: true)
                items.append(RepositorySectionItem.sizeItem(viewModel: sizeCellViewModel))
            }

            // Created
            if let created = repository.createdAt {
                let createdCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryCreatedCellTitle),
                                                                         detail: created.toRelative(),
                                                                         image: UIImage(resource: .iconCellCreated).template,
                                                                         hidesDisclosure: true)
                items.append(RepositorySectionItem.createdItem(viewModel: createdCellViewModel))
            }

            // Updated
            if let updated = repository.updatedAt {
                let updatedCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryUpdatedCellTitle),
                                                                         detail: updated.toRelative(),
                                                                         image: UIImage(resource: .iconCellUpdated).template,
                                                                         hidesDisclosure: true)
                items.append(RepositorySectionItem.updatedItem(viewModel: updatedCellViewModel))
            }

            // Homepage
            if let homepage = repository.homepage, homepage.isNotEmpty {
                let homepageCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryHomepageCellTitle),
                                                                         detail: homepage,
                                                                         image: UIImage(resource: .iconCellLink).template,
                                                                         hidesDisclosure: false)
                items.append(RepositorySectionItem.homepageItem(viewModel: homepageCellViewModel))
            }

            // Issues
            let issuesCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryIssuesCellTitle),
                                                                    detail: repository.openIssuesCount?.string ?? "",
                                                                    image: UIImage(resource: .iconCellIssues).template,
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.issuesItem(viewModel: issuesCellViewModel))

            // Pull Requests
            let pullRequestsCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryPullRequestsCellTitle),
                                                                          detail: repository.pullRequestsCount?.string ?? "",
                                                                          image: UIImage(resource: .iconCellGitPullRequest).template,
                                                                          hidesDisclosure: false)
            items.append(RepositorySectionItem.pullRequestsItem(viewModel: pullRequestsCellViewModel))

            // Commits
            let commitsCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryCommitsCellTitle),
                                                                     detail: repository.commitsCount?.string ?? "",
                                                                     image: UIImage(resource: .iconCellGitCommit).template,
                                                                     hidesDisclosure: false)
            items.append(RepositorySectionItem.commitsItem(viewModel: commitsCellViewModel))

            // Branches
            let branchesCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryBranchesCellTitle),
                                                                      detail: self.selectedBranch.value ?? repository.defaultBranch,
                                                                      image: UIImage(resource: .iconCellGitBranch).template,
                                                                      hidesDisclosure: false)
            items.append(RepositorySectionItem.branchesItem(viewModel: branchesCellViewModel))

            // Releases
            let releasesCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryReleasesCellTitle),
                                                                      detail: repository.releasesCount?.string ?? "",
                                                                      image: UIImage(resource: .iconCellReleases).template,
                                                                      hidesDisclosure: false)
            items.append(RepositorySectionItem.releasesItem(viewModel: releasesCellViewModel))

            // Contributors
            let contributorsCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryContributorsCellTitle),
                                                                          detail: repository.contributorsCount?.string ?? "",
                                                                          image: UIImage(resource: .iconCellCompany).template,
                                                                          hidesDisclosure: false)
            items.append(RepositorySectionItem.contributorsItem(viewModel: contributorsCellViewModel))

            // Events
            let eventsCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryEventsCellTitle),
                                                                    detail: "",
                                                                    image: UIImage(resource: .iconCellEvents).template,
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.eventsItem(viewModel: eventsCellViewModel))

            if loggedIn.value {
                // Notifications
                let notificationsCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryNotificationsCellTitle),
                                                                               detail: "",
                                                                               image: UIImage(resource: .iconTabbarActivity).template,
                                                                               hidesDisclosure: false)
                items.append(RepositorySectionItem.notificationsItem(viewModel: notificationsCellViewModel))
            }

            // Source
            let sourceCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositorySourceCellTitle),
                                                                    detail: "",
                                                                    image: UIImage(resource: .iconCellSource).template,
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.sourceItem(viewModel: sourceCellViewModel))

            // Stars history
            let starHistoryCellViewModel = RepositoryDetailCellViewModel(with: String(localized: .repositoryStarsHistoryCellTitle),
                                                                         detail: Configs.Network.starHistoryBaseUrl,
                                                                         image: UIImage(resource: .iconCellStarsHistory).template,
                                                                         hidesDisclosure: false)
            items.append(RepositorySectionItem.starHistoryItem(viewModel: starHistoryCellViewModel))

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

        default: return nil
        }
        return nil
    }

    func starHistoryUrl() -> URL? {
        return "\(Configs.Network.starHistoryBaseUrl)/#\(self.repository.value.fullname ?? "")".url
    }
}
