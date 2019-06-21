//
//  LanguagesViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/18/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.repoLanguageCell

class LanguagesViewController: TableViewController {

    lazy var saveButtonItem: BarButtonItem = {
        let view = BarButtonItem(title: "",
                                 style: .plain, target: self, action: nil)
        return view
    }()

    lazy var allButton: Button = {
        let view = Button()
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.navigationTitle = R.string.localizable.languagesNavigationTitle.key.localized()
            self?.saveButtonItem.title = R.string.localizable.commonSave.key.localized()
            self?.allButton.titleForNormal = R.string.localizable.languagesAllButtonTitle.key.localized()
        }).disposed(by: rx.disposeBag)

        navigationItem.rightBarButtonItem = saveButtonItem

        let allButtonView = View()
        allButtonView.addSubview(allButton)
        allButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(self.inset)
        }
        stackView.addArrangedSubview(allButtonView)
        stackView.insertArrangedSubview(searchBar, at: 0)

        tableView.register(R.nib.repoLanguageCell)
        tableView.headRefreshControl = nil
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? LanguagesViewModel else { return }

        let refresh = Observable.of(Observable.just(()),
                                    languageChanged.asObservable()).merge()
        let input = LanguagesViewModel.Input(trigger: refresh,
                                             saveTrigger: saveButtonItem.rx.tap.asDriver(),
                                             keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                             allTrigger: allButton.rx.tap.asDriver(),
                                             selection: tableView.rx.modelSelected(LanguageSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<LanguageSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .languageItem(let cellViewModel):
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)!
                cell.bind(to: cellViewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        output.items.asObservable()
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

        output.selectedRow.delay(DispatchTimeInterval.milliseconds(300)).drive(onNext: { [weak self] (indexPath) in
            self?.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }).disposed(by: rx.disposeBag)

        output.dismiss.drive(onNext: { [weak self] () in
            self?.navigator.dismiss(sender: self)
        }).disposed(by: rx.disposeBag)
    }
}
