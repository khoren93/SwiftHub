//
//  SettingCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/8/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class SettingCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.snp.remakeConstraints { (make) in
            make.size.equalTo(40)
        }
        detailLabel.isHidden = true
        attributedDetailLabel.isHidden = true
        secondDetailLabel.textAlignment = .right
        textsStackView.axis = .horizontal
        textsStackView.distribution = .fillEqually
    }
}
