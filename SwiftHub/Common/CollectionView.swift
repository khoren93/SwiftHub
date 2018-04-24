//
//  CollectionView.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class CollectionView: UICollectionView {

    init() {
        super.init(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
        makeUI()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        self.layer.masksToBounds = true
        self.backgroundColor = .clear
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func itemWidth(forItemsPerRow itemsPerRow: Int, withInset inset: CGFloat = 0) -> CGFloat {
        let collectionWidth = Int(frame.size.width)
        if collectionWidth == 0 {
            return 0
        }
        return CGFloat(Int((collectionWidth - (itemsPerRow + 1) * Int(inset)) / itemsPerRow))
    }

    func setItemSize(_ size: CGSize) {
        if size.width == 0 || size.height == 0 {
            return
        }
        let layout = (self.collectionViewLayout as? UICollectionViewFlowLayout)!
        layout.itemSize = size
    }
}
