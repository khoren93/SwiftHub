//
//  Label.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

/*
 Fonts
 System Font - 1, Bold System Font - 2

 Sizes
 17 - 1, 14 - 2, 12 - 3, 36 - 4,

 Colors
 Black - 1, Gray - 2, White - 3, Secondary - 4
 */
enum LabelStyle {
    case style111  // SFUIText-Medium, 17, Black
    case style112  // SFUIText-Medium, 17, Gray
    case style113  // SFUIText-Medium, 17, White
    case style114  // SFUIText-Medium, 17, Secondary

    case style211  // SFUIText-Bold, 17, Black
    case style212  // SFUIText-Bold, 17, Gray
    case style213  // SFUIText-Bold, 17, White
    case style214  // SFUIText-Bold, 17, Secondary

    case style121  // SFUIText-Medium, 14, Black
    case style122  // SFUIText-Medium, 14, Gray
    case style123  // SFUIText-Medium, 14, White
    case style124  // SFUIText-Medium, 14, Secondary

    case style221  // SFUIText-Bold, 14, Black
    case style222  // SFUIText-Bold, 14, Gray
    case style223  // SFUIText-Bold, 14, White
    case style224  // SFUIText-Bold, 14, Secondary

    case style131  // SFUIText-Medium, 12, Black
    case style132  // SFUIText-Medium, 12, Gray
    case style133  // SFUIText-Medium, 12, White
    case style134  // SFUIText-Medium, 12, Secondary

    case style231  // SFUIText-Bold, 12, Black
    case style232  // SFUIText-Bold, 12, Gray
    case style233  // SFUIText-Bold, 12, White
    case style234  // SFUIText-Bold, 12, Secondary

    var font: UIFont {
        switch self {
        case .style111, .style112, .style113, .style114: return UIFont(name: ".SFUIText-Medium", size: 17.0)!
        case .style211, .style212, .style213, .style214: return UIFont(name: ".SFUIText-Bold", size: 17.0)!
        case .style121, .style122, .style123, .style124: return UIFont(name: ".SFUIText-Medium", size: 14.0)!
        case .style221, .style222, .style223, .style224: return UIFont(name: ".SFUIText-Bold", size: 14.0)!
        case .style131, .style132, .style133, .style134: return UIFont(name: ".SFUIText-Medium", size: 12.0)!
        case .style231, .style232, .style233, .style234: return UIFont(name: ".SFUIText-Bold", size: 12.0)!
        }
    }

    var color: UIColor {
        switch self {
        case .style111, .style211, .style121, .style221, .style131, .style231: return .textBlack()
        case .style112, .style212, .style122, .style222, .style132, .style232: return .textGray()
        case .style113, .style213, .style123, .style223, .style133, .style233: return .flatWhite
        case .style114, .style214, .style124, .style224, .style134, .style234: return .secondary()
        }
    }
}

class Label: UILabel {

    var textInsets = UIEdgeInsets.zero {
        didSet { invalidateIntrinsicContentSize() }
    }

    var style = LabelStyle.style111 {
        didSet {
            updateUI()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    init(style: LabelStyle) {
        super.init(frame: CGRect())
        self.style = style
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

        font = style.font
        textColor = style.color
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
        set { textInsets.left = newValue }
        get { return textInsets.left }
    }

    var rightTextInset: CGFloat {
        set { textInsets.right = newValue }
        get { return textInsets.right }
    }

    var topTextInset: CGFloat {
        set { textInsets.top = newValue }
        get { return textInsets.top }
    }

    var bottomTextInset: CGFloat {
        set { textInsets.bottom = newValue }
        get { return textInsets.bottom }
    }
}
