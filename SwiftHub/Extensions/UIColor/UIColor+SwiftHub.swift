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
        return themeService.type.associatedObject.primary
    }

    static func primaryDark() -> UIColor {
        return themeService.type.associatedObject.primaryDark
    }

    static func secondary() -> UIColor {
        return themeService.type.associatedObject.secondary
    }

    static func secondaryDark() -> UIColor {
        return themeService.type.associatedObject.secondaryDark
    }

    static func separator() -> UIColor {
        return themeService.type.associatedObject.separator
    }

    static func text() -> UIColor {
        return themeService.type.associatedObject.text
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

extension UIColor {

    var brightnessAdjustedColor: UIColor {
        var components = self.cgColor.components
        let alpha = components?.last
        components?.removeLast()
        let color = CGFloat(1-(components?.max())! >= 0.5 ? 1.0 : 0.0)
        return UIColor(red: color, green: color, blue: color, alpha: alpha!)
    }
}
