//
//  UIColor+SwiftHub.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import ChameleonFramework

// MARK: Colors

extension UIColor {

    static func primary() -> UIColor {
        return flatBlack
    }

    static func primaryDark() -> UIColor {
        return flatBlackDark
    }

    static func secondary() -> UIColor {
        return flatRed
    }

    static func secondaryDark() -> UIColor {
        return flatRedDark
    }

    static func separator() -> UIColor {
        return flatBlackDark
    }

    static func textBlack() -> UIColor {
        return flatBlackDark
    }

    static func textWhite() -> UIColor {
        return white
    }

    static func textGray() -> UIColor {
        return .gray
    }
}

// MARK: Averaging a Color

extension UIColor {

    static func averageColor(fromImage image: UIImage?) -> UIColor? {
        guard let image = image else {
            return nil
        }
        return AverageColorFromImage(image)
    }
}

// MARK: Randomizing Colors

extension UIColor {

    static func randomColor() -> UIColor {
        return randomFlat
    }
}
