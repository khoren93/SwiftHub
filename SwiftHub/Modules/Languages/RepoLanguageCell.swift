//
//  RepoLanguageCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/18/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class RepoLanguageCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        rightImageView.image = selected ? R.image.icon_cell_check()?.template : nil
    }
}
