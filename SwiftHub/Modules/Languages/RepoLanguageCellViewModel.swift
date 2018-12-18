//
//  RepoLanguageCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/18/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RepoLanguageCellViewModel {

    let title: Driver<String>

    let language: Language

    init(with language: Language) {
        self.language = language
        title = Driver.just("\(language.name ?? "")")
    }
}
