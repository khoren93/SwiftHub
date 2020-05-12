//
//  ContributionsCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/12/20.
//  Copyright © 2020 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift

class ContributionsCell: TableViewCell {

    lazy var contributionsView: ContributionsView = {
        let view = ContributionsView()
        return view
    }()

    override func makeUI() {
        super.makeUI()
        stackView.addArrangedSubview(contributionsView)
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? ContributionsCellViewModel else { return }
        cellDisposeBag = DisposeBag()

        viewModel.contributionCalendar.bind(to: contributionsView.calendar).disposed(by: cellDisposeBag)
    }
}
