//
//  StackView.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/26/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class StackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        spacing = inset
        axis = .vertical
        // self.distribution = .fill

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
