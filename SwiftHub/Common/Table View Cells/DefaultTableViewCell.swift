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
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(Configs.BaseDimensions.tableRowHeight)
        })
        return view
    }()

    lazy var titleLabel: Label = {
        let view = Label(style: .style123)
        return view
    }()

    lazy var rightImageView: ImageView = {
        let view = ImageView(frame: CGRect())
        view.image = R.image.icon_cell_disclosure()?.withRenderingMode(.alwaysTemplate)
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(20)
        })
        return view
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if isSelection {
//            rightImageView.image = selected ? R.image.icon_selected() : R.image.icon_unselected()
        }
    }

    override func makeUI() {
        super.makeUI()

        themeService.rx
            .bind({ $0.text }, to: titleLabel.rx.textColor)
            .bind({ $0.secondary }, to: rightImageView.rx.tintColor)
            .disposed(by: rx.disposeBag)

        stackView.spacing = self.inset
        stackView.addArrangedSubview(leftImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(rightImageView)
        stackView.snp.remakeConstraints({ (make) in
            let inset = self.inset
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: inset/2, left: inset, bottom: inset/2, right: inset))
            make.height.equalTo(Configs.BaseDimensions.tableRowHeight)
        })
    }
}
