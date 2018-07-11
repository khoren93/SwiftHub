//
//  SectionType.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxDataSources

struct SectionType<T> {
    var header: String
    var items: [T]
}

extension SectionType: SectionModelType {
    typealias Item = T

    init(original: SectionType, items: [T]) {
        self = original
        self.items = items
    }
}
