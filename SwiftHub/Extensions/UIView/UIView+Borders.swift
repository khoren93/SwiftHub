//
//  UIView+Borders.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import Foundation

// MARK: - Create your borders and assign them to a property on a view when you can via the create methods when possible. Otherwise you might end up with multiple borders being created.
extension UIView {

    enum BorderSide {
        case left, top, right, bottom
    }

    func defaultBorderColor() -> UIColor {
        return UIColor.separator()
    }

    func defaultBorderDepth() -> CGFloat {
        return Configs.BaseDimensions.borderWidth
    }

    /// Add Border for side with default params
    ///
    /// - Parameter side: Border Side
    /// - Returns: Border view
    @discardableResult
    func addBorder(for side: BorderSide) -> UIView {
        return addBorder(for: side, color: defaultBorderColor(), depth: defaultBorderDepth())
    }

    /// Add Bottom Border with default params
    ///
    /// - Parameters:
    ///   - leftInset: left inset
    ///   - rightInset: right inset
    /// - Returns: Border view
    @discardableResult
    func addBottomBorder(leftInset: CGFloat = 10, rightInset: CGFloat = 0) -> UIView {
        let border = UIView()
        border.backgroundColor = defaultBorderColor()
        self.addSubview(border)
        border.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(leftInset)
            make.right.equalToSuperview().inset(rightInset)
            make.bottom.equalToSuperview()
            make.height.equalTo(self.defaultBorderDepth())
        }
        return border
    }

    /// Add Top Border for side with color, depth, length and offsets
    ///
    /// - Parameters:
    ///   - side: Border Side
    ///   - color: Border Color
    ///   - depth: Border Depth
    ///   - length: Border Length
    ///   - inset: Border Inset
    ///   - cornersInset: Border Corners Inset
    /// - Returns: Border view
    @discardableResult
    func addBorder(for side: BorderSide, color: UIColor, depth: CGFloat, length: CGFloat = 0.0, inset: CGFloat = 0.0, cornersInset: CGFloat = 0.0) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        self.addSubview(border)
        border.snp.makeConstraints { (make) in
            switch side {
            case .left:
                if length != 0.0 {
                    make.height.equalTo(length)
                    make.centerY.equalToSuperview()
                } else {
                    make.top.equalToSuperview().inset(cornersInset)
                    make.bottom.equalToSuperview().inset(cornersInset)
                }
                make.left.equalToSuperview().inset(inset)
                make.width.equalTo(depth)
            case .top:
                if length != 0.0 {
                    make.width.equalTo(length)
                    make.centerX.equalToSuperview()
                } else {
                    make.left.equalToSuperview().inset(cornersInset)
                    make.right.equalToSuperview().inset(cornersInset)
                }
                make.top.equalToSuperview().inset(inset)
                make.height.equalTo(depth)
            case .right:
                if length != 0.0 {
                    make.height.equalTo(length)
                    make.centerY.equalToSuperview()
                } else {
                    make.top.equalToSuperview().inset(cornersInset)
                    make.bottom.equalToSuperview().inset(cornersInset)
                }
                make.right.equalToSuperview().inset(inset)
                make.width.equalTo(depth)
            case .bottom:
                if length != 0.0 {
                    make.width.equalTo(length)
                    make.centerX.equalToSuperview()
                } else {
                    make.left.equalToSuperview().inset(cornersInset)
                    make.right.equalToSuperview().inset(cornersInset)
                }
                make.bottom.equalToSuperview().inset(inset)
                make.height.equalTo(depth)
            }
        }
        return border
    }
}
