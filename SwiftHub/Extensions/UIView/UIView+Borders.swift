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

    func defaultSize() -> CGFloat {
        return 1.0
    }

    func defaultColor() -> UIColor {
        return .separator()
    }

    // MARK: - Top Border

    /// Add Top Border with default params
    ///
    /// - returns: Border view
    func addTopBorder() -> UIView {
        return addTopBorder(height: defaultSize(), color: defaultColor(), left: 0.0, top: 0.0, right: 0.0)
    }

    /// Add Top Border with height and color
    ///
    /// - parameter height: Border Height
    /// - parameter color:  Border Color
    ///
    /// - returns: Border view
    func addTopBorder(height: CGFloat, color: UIColor) -> UIView {
        return addTopBorder(height: height, color: color, left: 0.0, top: 0.0, right: 0.0)
    }

    /// Add Top Border with height, color and offsets
    ///
    /// - parameter height: Border Height
    /// - parameter color:  Border Color
    /// - parameter left:   Left Offset
    /// - parameter top:    Top Offset
    /// - parameter right:  Right Offset
    ///
    /// - returns: Border view
    func addTopBorder(height: CGFloat, color: UIColor, left: CGFloat, top: CGFloat, right: CGFloat) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        self.addSubview(border)

        border.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(left)
            make.top.equalToSuperview().inset(top)
            make.right.equalToSuperview().inset(right)
            make.height.equalTo(height)
        }

        return border
    }

    // MARK: - Bottom Border

    /// Add Bottom Border with default params
    ///
    /// - returns: Border view
    func addBottomBorder() -> UIView {
        return addBottomBorder(height: defaultSize(), color: defaultColor(), left: 0.0, bottom: 0.0, right: 0.0)
    }

    /// Add Bottom Border with height and color
    ///
    /// - parameter height: Border Height
    /// - parameter color:  Border Color
    ///
    /// - returns: Border view
    func addBottomBorder(height: CGFloat, color: UIColor) -> UIView {
        return addBottomBorder(height: height, color: color, left: 0.0, bottom: 0.0, right: 0.0)
    }

    /// Add Bottom Border with height, color and offsets
    ///
    /// - parameter height: Border Height
    /// - parameter color:  Border Color
    /// - parameter left:   Left Offset
    /// - parameter bottom: Bottom Offset
    /// - parameter right:  Right Offset
    ///
    /// - returns: Border view
    func addBottomBorder(height: CGFloat, color: UIColor, left: CGFloat, bottom: CGFloat, right: CGFloat) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        self.addSubview(border)

        border.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(left)
            make.bottom.equalToSuperview().inset(bottom)
            make.right.equalToSuperview().inset(right)
            make.height.equalTo(height)
        }

        return border
    }

    // MARK: - Left Border

    /// Add Left Border with default params
    ///
    /// - returns: Border view
    func addLeftBorder() -> UIView {
        return addLeftBorder(width: defaultSize(), color: defaultColor(), left: 0.0, top: 0.0, bottom: 0.0)
    }

    /// Add Left Border with height and color
    ///
    /// - parameter width: Border Width
    /// - parameter color: Border Color
    ///
    /// - returns: Border view
    func addLeftBorder(width: CGFloat, color: UIColor) -> UIView {
        return addLeftBorder(width: width, color: color, left: 0.0, top: 0.0, bottom: 0.0)
    }

    /// Add Left Border with height, color and offsets
    ///
    /// - parameter width:  Border Width
    /// - parameter color:  Border Color
    /// - parameter left:   Left Offset
    /// - parameter top:    Top Offset
    /// - parameter bottom: Bottom Offset
    ///
    /// - returns: Border view
    func addLeftBorder(width: CGFloat, color: UIColor, left: CGFloat, top: CGFloat, bottom: CGFloat) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        self.addSubview(border)

        border.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(left)
            make.top.equalToSuperview().inset(top)
            make.bottom.equalToSuperview().inset(bottom)
            make.width.equalTo(width)
        }

        return border
    }

    // MARK: - Right Border

    /// Add Left Border with default params
    ///
    /// - returns: Border view
    func addRightBorder() -> UIView {
        return addRightBorder(width: defaultSize(), color: defaultColor(), right: 0.0, top: 0.0, bottom: 0.0)
    }

    /// Add Left Border with height and color
    ///
    /// - parameter width: Border Width
    /// - parameter color: Border Color
    ///
    /// - returns: Border view
    func addRightBorder(width: CGFloat, color: UIColor) -> UIView {
        return addRightBorder(width: width, color: color, right: 0.0, top: 0.0, bottom: 0.0)
    }

    /// Add Left Border with height, color and offsets
    ///
    /// - parameter width:  Border Width
    /// - parameter color:  Border Color
    /// - parameter right:  Right Offset
    /// - parameter top:    Top Offset
    /// - parameter bottom: Bottom Offset
    ///
    /// - returns: Border view
    func addRightBorder(width: CGFloat, color: UIColor, right: CGFloat, top: CGFloat, bottom: CGFloat) -> UIView {
        let border = UIView()
        border.backgroundColor = color
        self.addSubview(border)

        border.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(right)
            make.top.equalToSuperview().inset(top)
            make.bottom.equalToSuperview().inset(bottom)
            make.width.equalTo(width)
        }

        return border
    }
}
