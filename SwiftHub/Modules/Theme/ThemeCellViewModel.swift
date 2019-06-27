//
//  ThemeCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 9/15/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ThemeCellViewModel: DefaultTableViewCellViewModel {

    let imageColor = BehaviorRelay<UIColor?>(value: nil)

    let theme: ColorTheme

    init(with theme: ColorTheme) {
        self.theme = theme
        super.init()
        title.accept(theme.title)
        imageColor.accept(theme.color)
    }
}
