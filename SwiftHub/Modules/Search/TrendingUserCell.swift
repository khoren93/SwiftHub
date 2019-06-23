//
//  TrendingUserCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/18/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class TrendingUserCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.cornerRadius = 25
        leftImageView.snp.remakeConstraints { (make) in
            make.size.equalTo(50)
        }
    }
}
