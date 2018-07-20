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

    lazy var repositoriesButton: Button = {
        let view = Button()
        view.titleLabel?.lineBreakMode = .byWordWrapping
        view.snp.removeConstraints()
        return view
    }()

    lazy var followersButton: Button = {
        let view = Button()
        view.titleLabel?.lineBreakMode = .byWordWrapping
        view.snp.removeConstraints()
        return view
    }()

    lazy var followingButton: Button = {
        let view = Button()
        view.titleLabel?.lineBreakMode = .byWordWrapping
        view.snp.removeConstraints()
        return view
    }()

    lazy var actionButtonsStackView: StackView = {
        let subviews: [UIView] = [self.repositoriesButton, self.followersButton, self.followingButton]
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.addSubview(refreshControl)
    }

    override func makeUI() {
        super.makeUI()

        themeService.bind([
            ({ $0.primary }, [headerView.rx.backgroundColor])
        ]).disposed(by: rx.disposeBag)

        navigationItem.rightBarButtonItem = rightBarButton
        stackView.insertArrangedSubview(headerView, at: 0)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let pullToRefresh = Observable.of(Observable.just(()),
                                          refreshControl.rx.controlEvent(.valueChanged).asObservable()).merge()
        let input = RepositoryViewModel.Input(detailsTrigger: pullToRefresh,
                                              imageSelection: ownerImageView.rx.tapGesture().when(.recognized).mapToVoid(),
                                              openInWebSelection: rightBarButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        output.fetching.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

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
            self?.repositoriesButton.setAttributedTitle(self?.attributetText(title: "Watchers", value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.starsCount.drive(onNext: { [weak self] (count) in
            self?.followersButton.setAttributedTitle(self?.attributetText(title: "Stars", value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.forksCount.drive(onNext: { [weak self] (count) in
            self?.followingButton.setAttributedTitle(self?.attributetText(title: "Forks", value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.imageSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        output.openInWebSelected.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.navigator.show(segue: .webController(url), sender: self, transition: .modal)
            }
        }).disposed(by: rx.disposeBag)

        output.error.drive(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }

    func attributetText(title: String, value: Int) -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center

        let valueAttributes = Attributes {
            return $0.foreground(color: .textWhite())
                .font(.boldSystemFont(ofSize: 22))
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
