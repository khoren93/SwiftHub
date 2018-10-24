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

private let reuseIdentifier = R.reuseIdentifier.userDetailCell.identifier

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
        return view
    }()

    lazy var followersButton: Button = {
        let view = Button()
        return view
    }()

    lazy var followingButton: Button = {
        let view = Button()
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
    }

    override func makeUI() {
        super.makeUI()

        themeService.rx
            .bind({ $0.primaryDark }, to: headerView.rx.backgroundColor)
            .bind({ $0.text }, to: usernameLabel.rx.textColor)
            .bind({ $0.textGray }, to: fullnameLabel.rx.textColor)
            .disposed(by: rx.disposeBag)

        navigationItem.titleView = navigationHeaderView
        navigationItem.rightBarButtonItem = rightBarButton

        emptyDataSetTitle = ""
        emptyDataSetImage = nil
        stackView.insertArrangedSubview(headerView, at: 0)
        tableView.footRefreshControl = nil

        tableView.register(R.nib.userDetailCell)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger, languageChanged.asObservable()).merge()
        let input = UserViewModel.Input(headerRefresh: refresh,
                                        imageSelection: ownerImageView.rx.tapGesture().when(.recognized).mapToVoid(),
                                        openInWebSelection: rightBarButton.rx.tap.asObservable(),
                                        repositoriesSelection: repositoriesButton.rx.tap.asObservable(),
                                        followersSelection: followersButton.rx.tap.asObservable(),
                                        followingSelection: followingButton.rx.tap.asObservable(),
                                        selection: tableView.rx.modelSelected(UserSectionItem.self).asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .eventsItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserDetailCell)!
                cell.bind(to: viewModel)
                return cell
            }
        }, titleForHeaderInSection: { dataSource, index in
            let section = dataSource[index]
            return section.title
        })

        output.items
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: rx.disposeBag)

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
            let text = R.string.localizable.userRepositoriesButtonTitle.key.localized()
            self?.repositoriesButton.setAttributedTitle(self?.attributetText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followersCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.userFollowersButtonTitle.key.localized()
            self?.followersButton.setAttributedTitle(self?.attributetText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followingCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.userFollowingButtonTitle.key.localized()
            self?.followingButton.setAttributedTitle(self?.attributetText(title: text, value: count), for: .normal)
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
            self?.navigator.show(segue: .repositories(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.usersSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .users(viewModel: viewModel), sender: self, transition: .detail)
        }).disposed(by: rx.disposeBag)

        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
            case .eventsItem(let viewModel):
                if let viewModel = viewModel.destinationViewModel as? EventsViewModel {
                    self?.navigator.show(segue: .events(viewModel: viewModel), sender: self, transition: .detail)
                }
            }
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
