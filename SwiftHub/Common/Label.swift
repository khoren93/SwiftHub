//
//  Label.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

enum LabelStyle {
    case title
    case description
}

class Label: UILabel {

    let inset = Configs.BaseDimensions.Inset

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    init(type: LabelStyle) {
        super.init(frame: CGRect())
        makeUI()

        switch type {
        case .title:
            textColor = .textBlackColor()
            font = .titleFont()
            break
        case .description:
            textColor = .textGrayColor()
            font = .descriptionFont()
            break
        }
    }

    func makeUI() {
        layer.masksToBounds = true
        layer.cornerRadius = Configs.BaseDimensions.CornerRadius
        numberOfLines = 0

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
