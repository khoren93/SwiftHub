//
//  ContentsViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class ContentsViewModel: ViewModel, ViewModelType {

    struct Input {
        let headerRefresh: Observable<Void>
        let selection: Driver<ContentCellViewModel>
        let openInWebSelection: Observable<Void>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[ContentCellViewModel]>
        let openContents: Driver<ContentsViewModel>
        let openUrl: Driver<URL?>
        let openSource: Driver<SourceViewModel>
    }

    let repository: BehaviorRelay<Repository>
    let content: BehaviorRelay<Content?>
    let ref: BehaviorRelay<String?>

    init(repository: Repository, content: Content?, ref: String?, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        self.content = BehaviorRelay(value: content)
        self.ref = BehaviorRelay(value: ref)
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[ContentCellViewModel]>(value: [])

        input.headerRefresh.flatMapLatest({ [weak self] () -> Observable<[ContentCellViewModel]> in
            guard let self = self else { return Observable.just([]) }
            return self.request()
                .trackActivity(self.headerLoading)
        }).subscribe(onNext: { (items) in
            elements.accept(items)
        }).disposed(by: rx.disposeBag)

        let openContents = input.selection.map { $0.content }.filter { $0.type == .dir }
            .map({ (content) -> ContentsViewModel in
            let repository = self.repository.value
            let ref = self.ref.value
            let viewModel = ContentsViewModel(repository: repository, content: content, ref: ref, provider: self.provider)
            return viewModel
        })

        let openUrl = input.openInWebSelection.map { self.content.value?.htmlUrl?.url }
            .filterNil().asDriver(onErrorJustReturn: nil)

        let openSource = input.selection.map { $0.content }.filter { $0.type != .dir }.map { (content) -> SourceViewModel in
            let viewModel = SourceViewModel(content: content, provider: self.provider)
            return viewModel
        }

        let navigationTitle = content.map({ (content) -> String in
            return content?.name ?? self.repository.value.fullname ?? ""
        }).asDriver(onErrorJustReturn: "")

        return Output(navigationTitle: navigationTitle,
                      items: elements,
                      openContents: openContents,
                      openUrl: openUrl,
                      openSource: openSource)
    }

    func request() -> Observable<[ContentCellViewModel]> {
        let fullname = repository.value.fullname ?? ""
        let path = content.value?.path ?? ""
        let ref = self.ref.value
        return provider.contents(fullname: fullname, path: path, ref: ref)
            .trackActivity(loading)
            .trackError(error)
            .map { $0.sorted(by: { (lhs, rhs) -> Bool in
                if lhs.type == rhs.type {
                    return lhs.name?.lowercased() ?? "" < rhs.name?.lowercased() ?? ""
                } else {
                    return lhs.type > rhs.type
                }
            }).map { ContentCellViewModel(with: $0) } }
    }
}
