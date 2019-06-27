//
//  RepositoriesViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/20/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

private let reuseIdentifier = R.reuseIdentifier.repositoryCell.identifier

class RepositoriesViewController: TableViewController {

    lazy var ownerImageView: SlideImageView = {
        let view = SlideImageView()
        view.cornerRadius = 40
        return view
    }()

    lazy var headerView: View = {
        let view = View()
        view.hero.id = "TopHeaderId"
        view.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(self.inset)
            make.centerX.centerY.equalToSuperview()
            make.size.equalTo(80)
        })
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        themeService.rx
            .bind({ $0.primaryDark }, to: headerView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)

//        stackView.insertArrangedSubview(searchBar, at: 0)
        stackView.insertArrangedSubview(headerView, at: 0)

        tableView.register(R.nib.repositoryCell)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? RepositoriesViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = RepositoriesViewModel.Input(headerRefresh: refresh,
                                                footerRefresh: footerRefreshTrigger,
                                                keywordTrigger: searchBar.rx.text.orEmpty.asDriver(),
                                                textDidBeginEditing: searchBar.rx.textDidBeginEditing.asDriver(),
                                                selection: tableView.rx.modelSelected(RepositoryCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)
        viewModel.footerLoading.asObservable().bind(to: isFooterLoading).disposed(by: rx.disposeBag)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: reuseIdentifier, cellType: RepositoryCell.self)) { tableView, viewModel, cell in
                cell.bind(to: viewModel)
            }.disposed(by: rx.disposeBag)

        output.repositorySelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .repositoryDetails(viewModel: viewModel), sender: self, transition: .navigation(type: .fade))
        }).disposed(by: rx.disposeBag)

        output.dismissKeyboard.drive(onNext: { [weak self] () in
            self?.searchBar.resignFirstResponder()
        }).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }
}
