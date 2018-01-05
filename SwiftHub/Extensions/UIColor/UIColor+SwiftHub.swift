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

    static func primaryColor() -> UIColor {
        return .black
    }

    static func secondaryColor() -> UIColor {
        return flatWatermelon
    }

    static func separatorColor() -> UIColor {
        return flatWhite
    }

    static func textWhiteColor() -> UIColor {
        return .white
    }

    static func textBlackColor() -> UIColor {
        return flatBlack
    }

    static func textGrayColor() -> UIColor {
        return flatWhiteDark
    }
}

// MARK: Averaging a Color

extension UIColor {

    static func averageColor(fromImage image: UIImage) -> UIColor {
        return AverageColorFromImage(image)
    }
}

// MARK: Randomizing Colors

extension UIColor {

    static func randomColor() -> UIColor {
        return randomFlat
    }
}
