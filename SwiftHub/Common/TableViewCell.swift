//
//  TableViewCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    let inset = Configs.BaseDimensions.Inset

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func makeUI() {
        self.layer.masksToBounds = true
        self.selectionStyle = .none
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
