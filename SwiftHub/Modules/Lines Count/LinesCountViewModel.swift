//
//  LinesCountViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/16/20.
//  Copyright © 2020 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class LinesCountViewModel: ViewModel, ViewModelType {

    struct Input {
        let refresh: Observable<Void>
    }

    struct Output {
        let items: Driver<[LanguageLines]>
    }

    let repository: BehaviorRelay<Repository>

    init(repository: Repository, provider: SwiftHubAPI) {
        self.repository = BehaviorRelay(value: repository)
        super.init(provider: provider)
        if let fullname = repository.fullname {
            analytics.log(.linesCount(fullname: fullname))
        }
    }

    func transform(input: Input) -> Output {

        let elements = input.refresh.flatMapLatest { () -> Observable<[LanguageLines]> in
            let fullname = self.repository.value.fullname ?? ""
            return self.provider.numberOfLines(fullname: fullname)
                .trackActivity(self.loading)
                .trackError(self.error)
        }.asDriver(onErrorJustReturn: [])

        return Output(items: elements)
    }

    func color(for language: String) -> String? {
        guard let language = repository.value.languages?.languages.filter({ $0.name == language }).first else {
            return nil
        }
        return language.color
    }
}
