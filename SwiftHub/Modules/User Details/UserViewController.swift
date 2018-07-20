//
//  UserViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import AttributedLib

class UserViewController: TableViewController {

    var viewModel: UserViewModel!

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_github(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var usernameLabel: Label = {
        let view = Label(style: .style223)
        view.textAlignment = .center
        return view
    }()

    lazy var fullnameLabel: Label = {
        let view = Label(style: .style133)
        view.textAlignment = .center
        return view
    }()

    lazy var navigationHeaderView: StackView = {
        let subviews: [UIView] = [self.usernameLabel, self.fullnameLabel]
        let view = StackView(arrangedSubviews: subviews)
        view.spacing = 1
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
        view.backgroundColor = .primary()
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

        navigationItem.titleView = navigationHeaderView
        navigationItem.rightBarButtonItem = rightBarButton
//        stackView.insertArrangedSubview(searchBar, at: 0)
        stackView.insertArrangedSubview(headerView, at: 0)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let pullToRefresh = Observable.of(Observable.just(()),
                                          refreshControl.rx.controlEvent(.valueChanged).asObservable()).merge()
        let input = UserViewModel.Input(detailsTrigger: pullToRefresh,
                                        imageSelection: ownerImageView.rx.tapGesture().when(.recognized).mapToVoid(),
                                        openInWebSelection: rightBarButton.rx.tap.asObservable(),
                                        repositoriesSelection: repositoriesButton.rx.tap.asObservable(),
                                        followersSelection: followersButton.rx.tap.asObservable(),
                                        followingSelection: followingButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        output.fetching.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

        isLoading.subscribe(onNext: { [weak self] (isLoading) in
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        output.username.drive(usernameLabel.rx.text).disposed(by: rx.disposeBag)
        output.fullname.drive(fullnameLabel.rx.text).disposed(by: rx.disposeBag)
        output.fullname.map { $0.isEmpty }.drive(fullnameLabel.rx.isHidden).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.repositoriesCount.drive(onNext: { [weak self] (count) in
            self?.repositoriesButton.setAttributedTitle(self?.attributetText(title: "Repositories", value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followersCount.drive(onNext: { [weak self] (count) in
            self?.followersButton.setAttributedTitle(self?.attributetText(title: "Followers", value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followingCount.drive(onNext: { [weak self] (count) in
            self?.followingButton.setAttributedTitle(self?.attributetText(title: "Following", value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.imageSelected.drive(onNext: { [weak self] () in
            if let strongSelf = self {
                strongSelf.ownerImageView.presentFullScreenController(from: strongSelf)
            }
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
