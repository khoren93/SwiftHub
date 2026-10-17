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

private let reuseIdentifier = UserDetailCell.reuseID
private let repositoryReuseIdentifier = RepositoryCell.reuseID
private let organizationReuseIdentifier = UserCell.reuseID
private let contributionsReuseIdentifier = ContributionsCell.reuseID

class UserViewController: TableViewController {

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: UIImage(resource: .iconNavigationGithub), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var usernameLabel: Label = {
        let view = Label()
        view.textAlignment = .center
        return view
    }()

    lazy var fullnameLabel: Label = {
        let view = Label()
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
        view.layerCornerRadius = 50
        return view
    }()

    lazy var followButton: Button = {
        let view = Button()
        view.layerBorderColor = .white
        view.layerBorderWidth = Configs.BaseDimensions.borderWidth
        view.tintColor = .white
        view.layerCornerRadius = 20
        return view
    }()

    lazy var detailLabel: Label = {
        var view = Label()
        view.numberOfLines = 0
        return view
    }()

    lazy var headerStackView: StackView = {
        let headerView = View()
        headerView.addSubview(self.ownerImageView)
        self.ownerImageView.snp.makeConstraints({ (make) in
            make.top.left.centerX.centerY.equalToSuperview()
            make.size.equalTo(100)
        })
        headerView.addSubview(self.followButton)
        self.followButton.snp.remakeConstraints({ (make) in
            make.bottom.equalTo(self.ownerImageView)
            make.right.equalTo(self.ownerImageView)
            make.size.equalTo(40)
        })
        let subviews: [UIView] = [headerView, self.detailLabel]
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        return view
    }()

    lazy var headerView: View = {
        let view = View()
        let subviews: [UIView] = [self.headerStackView, self.actionButtonsStackView]
        let stackView = StackView(arrangedSubviews: subviews)
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

    override func makeUI() {
        super.makeUI()

        headerView.theme.backgroundColor = themeService.attribute { $0.primaryDark }
        usernameLabel.theme.textColor = themeService.attribute { $0.text }
        detailLabel.theme.textColor = themeService.attribute { $0.text }
        fullnameLabel.theme.textColor = themeService.attribute { $0.textGray }

        navigationItem.titleView = navigationHeaderView
        navigationItem.rightBarButtonItem = rightBarButton

        emptyDataSetTitle = ""
        emptyDataSetImage = nil
        stackView.insertArrangedSubview(headerView, at: 0)
        isFooterRefreshEnabled = false
        tableView.registerNib(UserDetailCell.self)
        tableView.registerNib(RepositoryCell.self)
        tableView.registerNib(UserCell.self)
        tableView.registerNib(ContributionsCell.self)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? UserViewModel else { return }

        let refresh = Observable.of(Observable.just(()), headerRefreshTrigger, languageChanged.asObservable()).merge()
        let input = UserViewModel.Input(headerRefresh: refresh,
                                        imageSelection: ownerImageView.rx.tap(),
                                        openInWebSelection: rightBarButton.rx.tap.asObservable(),
                                        repositoriesSelection: repositoriesButton.rx.tap.asObservable(),
                                        followersSelection: followersButton.rx.tap.asObservable(),
                                        followingSelection: followingButton.rx.tap.asObservable(),
                                        selection: tableView.rx.modelSelected(UserSectionItem.self).asDriver(),
                                        followSelection: followButton.rx.tap.asObservable())
        let output = viewModel.transform(input: input)

        let dataSource = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .contributionsItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: contributionsReuseIdentifier, for: indexPath) as? ContributionsCell)!
                cell.bind(to: viewModel)
                return cell
            case .createdItem(let viewModel),
                 .updatedItem(let viewModel),
                 .starsItem(let viewModel),
                 .watchingItem(let viewModel),
                 .eventsItem(let viewModel),
                 .companyItem(let viewModel),
                 .blogItem(let viewModel),
                 .profileSummaryItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? UserDetailCell)!
                cell.bind(to: viewModel)
                return cell
            case .repositoryItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: repositoryReuseIdentifier, for: indexPath) as? RepositoryCell)!
                cell.bind(to: viewModel)
                return cell
            case .organizationItem(let viewModel):
                let cell = (tableView.dequeueReusableCell(withIdentifier: organizationReuseIdentifier, for: indexPath) as? UserCell)!
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

        Observable.of(output.items.mapToVoid(), orientationEvent.asObservable()).merge()
            .asDriver(onErrorJustReturn: ()).delay(.milliseconds(100)).drive(onNext: { [weak self] (_) in
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
            }).disposed(by: rx.disposeBag)

        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
            case .contributionsItem:
                if let url = viewModel.skylineUrl() {
                    self?.deselectSelectedRow()
                    self?.navigator.show(segue: .safari(url), sender: self)
                }
            case .starsItem:
                if let viewModel = viewModel.viewModel(for: item) as? RepositoriesViewModel {
                    self?.navigator.show(segue: .repositories(viewModel: viewModel), sender: self)
                }
            case .watchingItem:
                if let viewModel = viewModel.viewModel(for: item) as? RepositoriesViewModel {
                    self?.navigator.show(segue: .repositories(viewModel: viewModel), sender: self)
                }
            case .eventsItem:
                if let viewModel = viewModel.viewModel(for: item) as? EventsViewModel {
                    self?.navigator.show(segue: .events(viewModel: viewModel), sender: self)
                }
            case .companyItem:
                if let viewModel = viewModel.viewModel(for: item) as? UserViewModel {
                    self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self)
                }
            case .blogItem:
                if let url = viewModel.user.value.blog?.url {
                    self?.navigator.show(segue: .webController(url), sender: self)
                }
            case .profileSummaryItem:
                if let url = viewModel.profileSummaryUrl() {
                    self?.navigator.show(segue: .webController(url), sender: self)
                }
            case .repositoryItem:
                if let viewModel = viewModel.viewModel(for: item) as? RepositoryViewModel {
                    self?.navigator.show(segue: .repositoryDetails(viewModel: viewModel), sender: self)
                }
            case .organizationItem:
                if let viewModel = viewModel.viewModel(for: item) as? UserViewModel {
                    self?.navigator.show(segue: .userDetails(viewModel: viewModel), sender: self)
                }
            default:
                self?.deselectSelectedRow()
            }
        }).disposed(by: rx.disposeBag)

        output.username.drive(usernameLabel.rx.text).disposed(by: rx.disposeBag)
        output.fullname.drive(fullnameLabel.rx.text).disposed(by: rx.disposeBag)
        output.fullname.map { $0.isEmpty }.drive(fullnameLabel.rx.isHidden).disposed(by: rx.disposeBag)
        output.description.drive(detailLabel.rx.text).disposed(by: rx.disposeBag)

        output.imageUrl.drive(onNext: { [weak self] (url) in
            if let url = url {
                self?.ownerImageView.setSources(sources: [url])
            }
        }).disposed(by: rx.disposeBag)

        output.hidesFollowButton.drive(followButton.rx.isHidden).disposed(by: rx.disposeBag)

        output.following.map { (followed) -> UIImage? in
            let image = followed ? UIImage(resource: .iconButtonUserX) : UIImage(resource: .iconButtonUserPlus)
            return image.template
        }.drive(followButton.rx.image()).disposed(by: rx.disposeBag)

        output.repositoriesCount.drive(onNext: { [weak self] (count) in
            let text = String(localized: .userRepositoriesButtonTitle)
            self?.repositoriesButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followersCount.drive(onNext: { [weak self] (count) in
            let text = String(localized: .userFollowersButtonTitle)
            self?.followersButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followingCount.drive(onNext: { [weak self] (count) in
            let text = String(localized: .userFollowingButtonTitle)
            self?.followingButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.imageSelected.drive(onNext: { [weak self] () in
            if let strongSelf = self {
                strongSelf.ownerImageView.present(from: strongSelf)
            }
        }).disposed(by: rx.disposeBag)

        output.openInWebSelected.filterNil().drive(onNext: { [weak self] (url) in
            self?.navigator.show(segue: .webController(url), sender: self, transition: .modal)
        }).disposed(by: rx.disposeBag)

        output.repositoriesSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .repositories(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)

        output.usersSelected.drive(onNext: { [weak self] (viewModel) in
            self?.navigator.show(segue: .users(viewModel: viewModel), sender: self)
        }).disposed(by: rx.disposeBag)
    }

    func attributedText(title: String, value: Int) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let titleText = title.styled([.foregroundColor: UIColor.white,
                                      .font: UIFont.boldSystemFont(ofSize: 12),
                                      .paragraphStyle: paragraphStyle])
        let valueText = value.string.styled([.foregroundColor: UIColor.white,
                                             .font: UIFont.boldSystemFont(ofSize: 18),
                                             .paragraphStyle: paragraphStyle])
        return NSAttributedString.composed(of: [
            titleText, .lineSeparator,
            valueText
        ])
    }
}
