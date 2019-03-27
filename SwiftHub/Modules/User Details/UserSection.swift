//
//  UserSection.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 10/13/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxDataSources

enum UserSection {
    case user(title: String, items: [UserSectionItem])
}

enum UserSectionItem {
    case createdItem(viewModel: UserDetailCellViewModel)
    case updatedItem(viewModel: UserDetailCellViewModel)
    case starsItem(viewModel: UserDetailCellViewModel)
    case watchingItem(viewModel: UserDetailCellViewModel)
    case eventsItem(viewModel: UserDetailCellViewModel)
    case companyItem(viewModel: UserDetailCellViewModel)
    case blogItem(viewModel: UserDetailCellViewModel)
    case profileSummaryItem(viewModel: UserDetailCellViewModel)

    case repositoryItem(viewModel: RepositoryCellViewModel)
    case organizationItem(viewModel: UserCellViewModel)
}

extension UserSection: SectionModelType {
    typealias Item = UserSectionItem

    var title: String {
        switch self {
        case .user(let title, _): return title
        }
    }

    var items: [UserSectionItem] {
        switch  self {
        case .user(_, let items): return items.map {$0}
        }
    }

    init(original: UserSection, items: [Item]) {
        switch original {
        case .user(let title, let items): self = .user(title: title, items: items)
        }
    }
}
