//
//  RepositorySection.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxDataSources

enum RepositorySection {
    case repository(title: String, items: [RepositorySectionItem])
}

enum RepositorySectionItem {
    case parentItem(viewModel: RepositoryDetailCellViewModel)
    case languageItem(viewModel: RepositoryDetailCellViewModel)
    case languagesItem(viewModel: LanguagesCellViewModel)
    case sizeItem(viewModel: RepositoryDetailCellViewModel)
    case createdItem(viewModel: RepositoryDetailCellViewModel)
    case updatedItem(viewModel: RepositoryDetailCellViewModel)
    case homepageItem(viewModel: RepositoryDetailCellViewModel)
    case issuesItem(viewModel: RepositoryDetailCellViewModel)
    case pullRequestsItem(viewModel: RepositoryDetailCellViewModel)
    case commitsItem(viewModel: RepositoryDetailCellViewModel)
    case branchesItem(viewModel: RepositoryDetailCellViewModel)
    case releasesItem(viewModel: RepositoryDetailCellViewModel)
    case contributorsItem(viewModel: RepositoryDetailCellViewModel)
    case eventsItem(viewModel: RepositoryDetailCellViewModel)
    case notificationsItem(viewModel: RepositoryDetailCellViewModel)
    case sourceItem(viewModel: RepositoryDetailCellViewModel)
    case starHistoryItem(viewModel: RepositoryDetailCellViewModel)
    case countLinesOfCodeItem(viewModel: RepositoryDetailCellViewModel)
}

extension RepositorySection: SectionModelType {
    typealias Item = RepositorySectionItem

    var title: String {
        switch self {
        case .repository(let title, _): return title
        }
    }

    var items: [RepositorySectionItem] {
        switch  self {
        case .repository(_, let items): return items.map {$0}
        }
    }

    init(original: RepositorySection, items: [Item]) {
        switch original {
        case .repository(let title, let items): self = .repository(title: title, items: items)
        }
    }
}
