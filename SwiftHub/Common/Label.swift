//
//  Label.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class Label: UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        layer.masksToBounds = true
        numberOfLines = 1
//        cornerRadius = Configs.BaseDimensions.cornerRadius
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}

extension Label {

    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insetRect = bounds.inset(by: textInsets)
        let textRect = super.textRect(forBounds: insetRect, limitedToNumberOfLines: numberOfLines)
        let invertedInsets = UIEdgeInsets(top: -textInsets.top,
                                          left: -textInsets.left,
                                          bottom: -textInsets.bottom,
                                          right: -textInsets.right)
        return textRect.inset(by: invertedInsets)
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    var leftTextInset: CGFloat {
        get { return textInsets.left }
        set { textInsets.left = newValue }
    }

    var rightTextInset: CGFloat {
        get { return textInsets.right }
        set { textInsets.right = newValue }
    }

    var topTextInset: CGFloat {
        get { return textInsets.top }
        set { textInsets.top = newValue }
    }

    var bottomTextInset: CGFloat {
        get { return textInsets.bottom }
        set { textInsets.bottom = newValue }
    }
}
