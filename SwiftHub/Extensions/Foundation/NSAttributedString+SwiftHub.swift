//
//  NSAttributedString+SwiftHub.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 10/18/26.
//  Copyright © 2026 Khoren Markosyan. All rights reserved.
//

import UIKit

extension String {

    func styled(_ attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attributes)
    }
}

extension UIImage {

    /// The image as an inline text attachment
    func styled(_ attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let string = NSMutableAttributedString(attachment: NSTextAttachment(image: self))
        string.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
        return string
    }
}

extension NSAttributedString {

    static let space = NSAttributedString(string: " ")
    static let tab = NSAttributedString(string: "\t")
    static let lineSeparator = NSAttributedString(string: "\u{2028}")

    /// Empty horizontal gap of a fixed width
    static func spacer(width: CGFloat) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.bounds = CGRect(x: 0, y: 0, width: width, height: 0)
        return NSAttributedString(attachment: attachment)
    }

    static func composed(of parts: [NSAttributedString]) -> NSAttributedString {
        let result = NSMutableAttributedString()
        parts.forEach { result.append($0) }
        return result
    }
}
