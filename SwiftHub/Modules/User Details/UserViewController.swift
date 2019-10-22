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
import BonMot

private let reuseIdentifier = R.reuseIdentifier.userDetailCell.identifier
private let repositoryReuseIdentifier = R.reuseIdentifier.repositoryCell.identifier
private let organizationReuseIdentifier = R.reuseIdentifier.userCell.identifier

class UserViewController: TableViewController {

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_github(), style: .done, target: nil, action: nil)
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
        view.cornerRadius = 50
        return view
    }()

    lazy var followButton: Button = {
        let view = Button()
        view.borderColor = .white
        view.borderWidth = Configs.BaseDimensions.borderWidth
        view.tintColor = .white
        view.cornerRadius = 20
        view.hero.id = "ActionButtonId"
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
        view.hero.id = "TopHeaderId"
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        themeService.rx
            .bind({ $0.primaryDark }, to: headerView.rx.backgroundColor)
            .bind({ $0.text }, to: [usernameLabel.rx.textColor, detailLabel.rx.textColor])
            .bind({ $0.textGray }, to: fullnameLabel.rx.textColor)
            .disposed(by: rx.disposeBag)

        navigationItem.titleView = navigationHeaderView
        navigationItem.rightBarButtonItem = rightBarButton

        emptyDataSetTitle = ""
        emptyDataSetImage = nil
        stackView.insertArrangedSubview(headerView, at: 0)
        tableView.footRefreshControl = nil
        tableView.register(R.nib.userDetailCell)
        tableView.register(R.nib.repositoryCell)
        tableView.register(R.nib.userCell)
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

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)
        viewModel.headerLoading.asObservable().bind(to: isHeaderLoading).disposed(by: rx.disposeBag)

        let dataSource = RxTableViewSectionedReloadDataSource<UserSection>(configureCell: { dataSource, tableView, indexPath, item in
            switch item {
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

        output.selectedEvent.drive(onNext: { [weak self] (item) in
            switch item {
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
                self?.ownerImageView.hero.id = url.absoluteString
            }
        }).disposed(by: rx.disposeBag)

        output.hidesFollowButton.drive(followButton.rx.isHidden).disposed(by: rx.disposeBag)

        output.following.map { (followed) -> UIImage? in
            let image = followed ? R.image.icon_button_user_x() : R.image.icon_button_user_plus()
            return image?.template
        }.drive(followButton.rx.image()).disposed(by: rx.disposeBag)

        output.repositoriesCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.userRepositoriesButtonTitle.key.localized()
            self?.repositoriesButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followersCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.userFollowersButtonTitle.key.localized()
            self?.followersButton.setAttributedTitle(self?.attributedText(title: text, value: count), for: .normal)
        }).disposed(by: rx.disposeBag)

        output.followingCount.drive(onNext: { [weak self] (count) in
            let text = R.string.localizable.userFollowingButtonTitle.key.localized()
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

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(), message: error.localizedDescription)
        }).disposed(by: rx.disposeBag)
    }

    func attributedText(title: String, value: Int) -> NSAttributedString {
        let titleText = title.styled(with: .color(.white),
                                     .font(.boldSystemFont(ofSize: 12)),
                                     .alignment(.center))
        let valueText = value.string.styled(with: .color(.white),
                                            .font(.boldSystemFont(ofSize: 18)),
                                            .alignment(.center))
        return NSAttributedString.composed(of: [
            titleText, Special.nextLine,
            valueText
        ])
    }
}
