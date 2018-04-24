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
        return flatNavyBlue
    }

    static func primaryDark() -> UIColor {
        return flatNavyBlueDark
    }

    static func secondary() -> UIColor {
        return flatSkyBlue
    }

    static func secondaryDark() -> UIColor {
        return flatSkyBlueDark
    }

    static func separator() -> UIColor {
        return flatWhite
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
