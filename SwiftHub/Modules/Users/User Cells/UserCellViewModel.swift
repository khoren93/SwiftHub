//
//  UserCellViewModel.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let imageUrl: Driver<URL?>

    let user: User

    init(with user: User) {
        self.user = user
        title = Driver.just("\(user.name ?? "")")
        detail = Driver.just("\(user.bio ?? "")")
        imageUrl = Driver.just(user.avatarUrl?.url)
    }
}
