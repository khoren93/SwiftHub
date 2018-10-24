//
//  RepositoryViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/1/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AttributedLib

class RepositoryViewController: TableViewController {

    var viewModel: RepositoryViewModel!

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_github(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var ownerImageView: SlideImageView = {
        let view = SlideImageView()
        view.cornerRadius = 40
        return view
    }()

    lazy var headerStackView: StackView = {
        let imageView = View()
        imageView.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.centerX.centerY.equalToSuperview()
            make.size.equalTo(80)
        })
        let subviews: [UIView] = [imageView]
        let view = StackView(arrangedSubviews: subviews)
        return view
    }()

    lazy var headerView: View = {
        let view = View()
        view.hero.id = "TopHeaderId"
        let subviews: [UIView] = [self.headerStackView, self.actionButtonsStackView]
        let stackView = StackView(arrangedSubviews: subviews)
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(self.inset)
        })
        return view
    }()

    lazy var watchersButton: Button = {
        let view = Button()
        return view
    }()

    lazy var starsButton: Button = {
        let view = Button()
        return view
    }()

    lazy var forksButton: Button = {
        let view = Button()
        return view
    }()

    lazy var actionButtonsStackView: StackView = {
        let subviews: [UIView] = [self.watchersButton, self.starsButton, self.forksButton]
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.distribution = .fillEqually
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

        navigationItem.rightBarButtonItem = rightBarButton
        emptyDataSetTitle = ""
        emptyDataSetImage = nil
        stackView.insertArrangedSubview(headerView, at: 0)
        tableView.footRefreshControl = nil
    }

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger).merge()
        let input = RepositoryViewModel.Input(headerRefresh: refresh,
                                              imageSelection: ownerImageView.rx.tapGesture().when(.recognized).mapToVoid(),
                                              openInWebSelection: rightBarButton.rx.tap.asObservable(),
                                              watchersSelection: watchersButton.rx.tap.asObservable(),
                                              starsSelection: starsButton.rx.tap.asObservable(),
                                              forksSelection: forksButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)

        output.name.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.watchersCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.repositoryWatchersButtonTitle.key.localized()
            self?.watchersButton.setAttributedTitle(self?.attributetText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.starsCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.repositoryStarsButtonTitle.key.localized()
            self?.starsButton.setAttributedTitle(self?.attributetText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.forksCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.repositoryForksButtonTitle.key.localized()
            self?.forksButton.setAttributedTitle(self?.attributetText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.imageSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        output.openInWebSelected.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.navigator.show(segue: .webController(url), sender: self, transition: .modal)
            }
        }).disposed(by: rx.disposeBag)

        output.repositoriesSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .repositories(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        output.usersSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .users(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)
    }

    func attributetText(title: String, value: Int) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let valueAttributes = Attributes {
            return $0.foreground(color: .textWhite())
                .font(.boldSystemFont(ofSize: 20))
                .paragraphStyle(paragraph)
        }

        let titleAttributes = Attributes {
            return $0.foreground(color: .textWhite())
                .font(.boldSystemFont(ofSize: 14))
                .paragraphStyle(paragraph)
        }

        return "\(value)\n".at.attributed(with: valueAttributes) + title.at.attributed(with: titleAttributes)
    }
}
