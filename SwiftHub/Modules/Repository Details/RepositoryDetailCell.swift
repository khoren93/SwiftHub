//
//  RepositoryDetailCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/5/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class RepositoryDetailCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.layerCornerRadius = 0
        leftImageView.snp.updateConstraints { (make) in
            make.size.equalTo(30)
        }
        detailLabel.isHidden = true
        attributedDetailLabel.isHidden = true
        secondDetailLabel.textAlignment = .right
        textsStackView.axis = .horizontal
        textsStackView.distribution = .fillEqually
    }
}
