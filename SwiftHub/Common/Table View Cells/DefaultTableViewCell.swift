//
//  DefaultTableViewCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class DefaultTableViewCell: TableViewCell {

    lazy var leftImageView: ImageView = {
        let view = ImageView(frame: CGRect())
        view.contentMode = .scaleAspectFit
        view.cornerRadius = 25
        view.snp.makeConstraints({ (make) in
            make.size.equalTo(50)
        })
        return view
    }()

    lazy var badgeImageView: ImageView = {
        let view = ImageView(frame: CGRect())
        view.backgroundColor = .white
        view.cornerRadius = 10
        view.borderColor = .white
        view.borderWidth = 1
        containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.bottom.left.equalTo(self.leftImageView)
            make.size.equalTo(20)
        })
        return view
    }()

    lazy var titleLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(14)
        return view
    }()

    lazy var detailLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(12)
        view.setPriority(UILayoutPriority.defaultLow, for: NSLayoutConstraint.Axis.vertical)
        return view
    }()

    lazy var secondDetailLabel: Label = {
        let view = Label()
        view.font = view.font.bold.withSize(11)
        return view
    }()

    lazy var attributedDetailLabel: Label = {
        let view = Label()
        view.font = view.font.bold.withSize(11)
        return view
    }()

    lazy var textsStackView: StackView = {
        let views: [UIView] = [self.titleLabel, self.detailLabel, self.secondDetailLabel, self.attributedDetailLabel]
        let view = StackView(arrangedSubviews: views)
        view.spacing = 2
        return view
    }()

    lazy var rightImageView: ImageView = {
        let view = ImageView(frame: CGRect())
        view.image = R.image.icon_cell_disclosure()?.template
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(20)
        })
        return view
    }()

    override func makeUI() {
        super.makeUI()

        titleLabel.theme.textColor = themeService.attribute { $0.text }
        detailLabel.theme.textColor = themeService.attribute { $0.textGray }
        secondDetailLabel.theme.textColor = themeService.attribute { $0.text }
        leftImageView.theme.tintColor = themeService.attribute { $0.secondary }
        rightImageView.theme.tintColor = themeService.attribute { $0.secondary }

        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(textsStackView)
        stackView.addArrangedSubview(rightImageView)
        stackView.snp.remakeConstraints({ (make) in
            let inset = self.inset
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: inset/2, left: inset, bottom: inset/2, right: inset))
            make.height.greaterThanOrEqualTo(Configs.BaseDimensions.tableRowHeight)
        })
    }

    override func bind(to viewModel: TableViewCellViewModel) {
        super.bind(to: viewModel)
        guard let viewModel = viewModel as? DefaultTableViewCellViewModel else { return }

        viewModel.title.asDriver().drive(titleLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.title.asDriver().replaceNilWith("").map { $0.isEmpty }.drive(titleLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.detail.asDriver().drive(detailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.detail.asDriver().replaceNilWith("").map { $0.isEmpty }.drive(detailLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.secondDetail.asDriver().drive(secondDetailLabel.rx.text).disposed(by: rx.disposeBag)
        viewModel.secondDetail.asDriver().replaceNilWith("").map { $0.isEmpty }.drive(secondDetailLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.attributedDetail.asDriver().drive(attributedDetailLabel.rx.attributedText).disposed(by: rx.disposeBag)
        viewModel.attributedDetail.asDriver().map { $0 == nil }.drive(attributedDetailLabel.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.badge.asDriver().drive(badgeImageView.rx.image).disposed(by: rx.disposeBag)
        viewModel.badge.map { $0 == nil }.asDriver(onErrorJustReturn: true).drive(badgeImageView.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.badgeColor.asDriver().drive(badgeImageView.rx.tintColor).disposed(by: rx.disposeBag)

        viewModel.hidesDisclosure.asDriver().drive(rightImageView.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.image.asDriver().filterNil()
            .drive(leftImageView.rx.image).disposed(by: rx.disposeBag)

        viewModel.imageUrl.map { $0?.url }.asDriver(onErrorJustReturn: nil).filterNil()
            .drive(leftImageView.rx.imageURL).disposed(by: rx.disposeBag)

        viewModel.imageUrl.asDriver().filterNil()
            .drive(onNext: { [weak self] (url) in
                self?.leftImageView.hero.id = url
            }).disposed(by: rx.disposeBag)
    }
}
