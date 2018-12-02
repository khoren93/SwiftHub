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
    }

    struct Output {
        let items: Observable<[RepositorySection]>
        let name: Driver<String>
        let description: Driver<String>
        let imageUrl: Driver<URL?>
        let watchersCount: Driver<Int>
        let starsCount: Driver<Int>
        let forksCount: Driver<Int>
        let imageSelected: Driver<UserViewModel>
        let openInWebSelected: Driver<URL?>
        let repositoriesSelected: Driver<RepositoriesViewModel>
        let usersSelected: Driver<UsersViewModel>
        let selectedEvent: Driver<RepositorySectionItem>
    }

    let repository: BehaviorRelay<Repository>
    let readme = BehaviorRelay<Content?>(value: nil)

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
        if let fullName = repository.fullName {
            analytics.log(.repository(fullname: fullName))
        }
    }

    func transform(input: Input) -> Output {

        input.headerRefresh.flatMapLatest { [weak self] () -> Observable<Repository> in
            guard let self = self else { return Observable.just(Repository()) }
            let fullName = self.repository.value.fullName ?? ""
            return self.provider.repository(fullName: fullName)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (repository) in
                self?.repository.accept(repository)
            }).disposed(by: rx.disposeBag)

        input.headerRefresh.flatMapLatest { [weak self] () -> Observable<Content> in
            guard let self = self else { return Observable.just(Content()) }
            let fullName = self.repository.value.fullName ?? ""
            return self.provider.readme(fullName: fullName, ref: nil)
                .trackActivity(self.loading)
                .trackActivity(self.headerLoading)
                .trackError(self.error)
            }.subscribe(onNext: { [weak self] (content) in
                self?.readme.accept(content)
            }).disposed(by: rx.disposeBag)

        let name = repository.map { $0.fullName ?? "" }.asDriverOnErrorJustComplete()
        let description = repository.map { $0.descriptionField ?? "" }.asDriverOnErrorJustComplete()
        let watchersCount = repository.map { $0.subscribersCount ?? 0 }.asDriverOnErrorJustComplete()
        let starsCount = repository.map { $0.stargazersCount ?? 0 }.asDriverOnErrorJustComplete()
        let forksCount = repository.map { $0.forks ?? 0 }.asDriverOnErrorJustComplete()
        let imageUrl = repository.map { $0.owner?.avatarUrl?.url }.asDriverOnErrorJustComplete()

        let imageSelected = input.imageSelection.asDriver(onErrorJustReturn: ())
            .map { () -> UserViewModel in
                let user = self.repository.value.owner ?? User()
                let viewModel = UserViewModel(user: user, provider: self.provider)
                return viewModel
        }

        let openInWebSelected = input.openInWebSelection.map { () -> URL? in
            self.repository.value.htmlUrl?.url
        }.asDriver(onErrorJustReturn: nil)

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

        let items = repository.map { (repository) -> [RepositorySection] in
            var items: [RepositorySectionItem] = []

            // Language
            if let language = repository.language {
                let languageCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryLanguageCellTitle.key.localized(),
                                                                          detail: language,
                                                                          image: R.image.icon_cell_git_language(),
                                                                          hidesDisclosure: true)
                items.append(RepositorySectionItem.languageItem(viewModel: languageCellViewModel))
            }

            // Size
            if let size = repository.size {
                let sizeCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositorySizeCellTitle.key.localized(),
                                                                      detail: size.size(),
                                                                      image: R.image.icon_cell_size(),
                                                                      hidesDisclosure: true)
                items.append(RepositorySectionItem.sizeItem(viewModel: sizeCellViewModel))
            }

            // Created
            if let created = repository.createdAt {
                let createdCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryCreatedCellTitle.key.localized(),
                                                                         detail: created.toRelative(),
                                                                         image: R.image.icon_cell_created(),
                                                                         hidesDisclosure: true)
                items.append(RepositorySectionItem.createdItem(viewModel: createdCellViewModel))
            }

            // Updated
            if let updated = repository.updatedAt {
                let updatedCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryUpdatedCellTitle.key.localized(),
                                                                         detail: updated.toRelative(),
                                                                         image: R.image.icon_cell_updated(),
                                                                         hidesDisclosure: true)
                items.append(RepositorySectionItem.updatedItem(viewModel: updatedCellViewModel))
            }

            // Homepage
            if let homepage = repository.homepage, homepage.isNotEmpty {
                let homepageCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryHomepageCellTitle.key.localized(),
                                                                         detail: homepage,
                                                                         image: R.image.icon_cell_link(),
                                                                         hidesDisclosure: false)
                items.append(RepositorySectionItem.homepageItem(viewModel: homepageCellViewModel))
            }

            // Issues
            if let issues = repository.openIssuesCount?.string {
                let issuesCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryIssuesCellTitle.key.localized(),
                                                                        detail: issues,
                                                                        image: R.image.icon_cell_issues(),
                                                                        hidesDisclosure: false)
                items.append(RepositorySectionItem.issuesItem(viewModel: issuesCellViewModel))
            }

            // Commits
            let commitsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryCommitsCellTitle.key.localized(),
                                                                          detail: "",
                                                                          image: R.image.icon_cell_git_commit(),
                                                                          hidesDisclosure: false)
            items.append(RepositorySectionItem.commitsItem(viewModel: commitsCellViewModel))

            // Pull Requests
            let pullRequestsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryPullRequestsCellTitle.key.localized(),
                                                                          detail: "",
                                                                          image: R.image.icon_cell_git_pull_request(),
                                                                          hidesDisclosure: false)
            items.append(RepositorySectionItem.pullRequestsItem(viewModel: pullRequestsCellViewModel))

            // Events
            let eventsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryEventsCellTitle.key.localized(),
                                                                    detail: "",
                                                                    image: R.image.icon_cell_events(),
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.eventsItem(viewModel: eventsCellViewModel))

            // Contributors
            let contributorsCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryContributorsCellTitle.key.localized(),
                                                                    detail: "",
                                                                    image: R.image.icon_cell_company(),
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.contributorsItem(viewModel: contributorsCellViewModel))

            // Readme
            let readmeCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositoryReadmeCellTitle.key.localized(),
                                                                    detail: "",
                                                                    image: R.image.icon_cell_readme(),
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.readmeItem(viewModel: readmeCellViewModel))

            // Source
            let sourceCellViewModel = RepositoryDetailCellViewModel(with: R.string.localizable.repositorySourceCellTitle.key.localized(),
                                                                    detail: "",
                                                                    image: R.image.icon_cell_source(),
                                                                    hidesDisclosure: false)
            items.append(RepositorySectionItem.sourceItem(viewModel: sourceCellViewModel))

            return [
                RepositorySection.repository(title: "", items: items)
            ]
        }

        let selectedEvent = input.selection

        return Output(items: items,
                      name: name,
                      description: description,
                      imageUrl: imageUrl,
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
        case .issuesItem:
            let viewModel = IssuesViewModel(repository: repository.value, provider: provider)
            return viewModel

        case .commitsItem:
            let viewModel = CommitsViewModel(repository: repository.value, provider: provider)
            return viewModel

        case .pullRequestsItem:
            let viewModel = PullRequestsViewModel(repository: repository.value, provider: provider)
            return viewModel

        case .eventsItem:
            let mode = EventsMode.repository(repository: repository.value)
            let viewModel = EventsViewModel(mode: mode, provider: provider)
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
    }
}
