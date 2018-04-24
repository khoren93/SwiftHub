//
//  CollectionViewCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    func makeUI() {
        self.layer.masksToBounds = true
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
