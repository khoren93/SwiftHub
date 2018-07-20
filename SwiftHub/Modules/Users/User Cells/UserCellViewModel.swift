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
        title = Driver.just("\(user.login ?? "")")
        detail = Driver.just("\(user.name ?? "")")
        imageUrl = Driver.just(user.avatarUrl?.url)
    }
}

extension UserCellViewModel: Equatable {
    static func == (lhs: UserCellViewModel, rhs: UserCellViewModel) -> Bool {
        return lhs.user == rhs.user
    }
}
