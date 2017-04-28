//
//  UIColor+SwiftHub.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import Chameleon

// MARK: SwiftHub Colors

extension UIColor {

    static func primaryColor() -> UIColor {
        return .black
    }

    static func secondaryColor() -> UIColor {
        return flatWatermelon()
    }

    static func separatorColor() -> UIColor {
        return flatWhite()
    }

    static func textWhiteColor() -> UIColor {
        return .white
    }

    static func textBlackColor() -> UIColor {
        return flatBlack()
    }

    static func textGrayColor() -> UIColor {
        return flatWhiteColorDark()
    }
}

// MARK: All Colors

extension UIColor {

    static func lightColors() -> [UIColor] {
        return
            [flatRed(), flatOrange(), flatYellow(), flatSand(),
             flatNavyBlue(), flatBlack(), flatMagenta(), flatTeal(),
             flatSkyBlue(), flatGreen(), flatMint(), flatWhite(),
             flatGray(), flatForestGreen(), flatPurple(), flatBrown(),
             flatPlum(), flatWatermelon(), flatLime(), flatPink(),
             flatMaroon(), flatCoffee(), flatPowderBlue(), flatBlue()]
    }

    static func darkColors() -> [UIColor] {
        return
            [flatRedColorDark(), flatOrangeColorDark(), flatYellowColorDark(), flatSandColorDark(),
             flatNavyBlueColorDark(), flatBlackColorDark(), flatMagentaColorDark(), flatTealColorDark(),
             flatSkyBlueColorDark(), flatGreenColorDark(), flatMintColorDark(), flatWhiteColorDark(),
             flatGrayColorDark(), flatForestGreenColorDark(), flatPurpleColorDark(), flatBrownColorDark(),
             flatPlumColorDark(), flatWatermelonColorDark(), flatLimeColorDark(), flatPinkColorDark(),
             flatMaroonColorDark(), flatCoffeeColorDark(), flatPowderBlueColorDark(), flatBlueColorDark()]
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
        return randomFlat()
    }
}
