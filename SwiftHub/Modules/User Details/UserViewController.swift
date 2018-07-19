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

class UserViewController: TableViewController {

    var viewModel: UserViewModel!

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_github(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var ownerImageView: SlideImageView = {
        let view = SlideImageView()
        view.cornerRadius = 40
        return view
    }()

    lazy var usernameLabel: Label = {
        let view = Label(style: .style213)
        view.textAlignment = .center
        return view
    }()

    lazy var fullnameLabel: Label = {
        let view = Label(style: .style123)
        view.textAlignment = .center
        return view
    }()

    lazy var headerStackView: StackView = {
        let imageView = View()
        imageView.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.centerX.centerY.equalToSuperview()
            make.size.equalTo(80)
        })
        let subviews: [UIView] = [imageView, self.usernameLabel, self.fullnameLabel]
        let view = StackView(arrangedSubviews: subviews)
//        view.distribution = .equalCentering
//        view.spacing = self.inset
        return view
    }()

    lazy var headerView: View = {
        let view = View(frame: CGRect(x: 0, y: 0, width: 0, height: 160))
        view.backgroundColor = .primary()
        view.hero.id = "TopHeaderId"
        let subviews: [UIView] = [self.headerStackView]
        let stackView = StackView(arrangedSubviews: subviews)
        stackView.axis = .horizontal
        stackView.alignment = .bottom
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().inset(self.inset)
            make.centerX.centerY.equalToSuperview()
        })
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.addSubview(refreshControl)
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.rightBarButtonItem = rightBarButton
        tableView.tableHeaderView = headerView
    }

    override func bindViewModel() {
        super.bindViewModel()

        let pullToRefresh = Observable.of(Observable.just(()),
                                          refreshControl.rx.controlEvent(.valueChanged).asObservable()).merge()
        let input = UserViewModel.Input(detailsTrigger: pullToRefresh,
                                        imageSelection: ownerImageView.rx.tapGesture().when(.recognized).mapToVoid(),
                                        openInWebSelection: rightBarButton.rx.tap.asObservable())
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

        output.error.drive(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }
}
