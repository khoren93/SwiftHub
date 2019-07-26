//
//  LanguagesCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/26/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class LanguagesCellViewModel: NSObject {

    let languages: Languages?

    init(languages: Languages) {
        self.languages = languages
    }
}
