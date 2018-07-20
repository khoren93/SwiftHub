//
//  ThemeManager.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/21/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxTheme

protocol Theme {
    var primary: UIColor { get }
    var primaryDark: UIColor { get }
    var secondary: UIColor { get }
    var secondaryDark: UIColor { get }
    var separator: UIColor { get }
    var text: UIColor { get }
    var textGray: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }
}

struct LightTheme: Theme {
    let primary = UIColor.white
    let primaryDark = UIColor.flatWhiteDark
    let secondary = UIColor.flatRed
    let secondaryDark = UIColor.flatRedDark
    let separator = UIColor.flatWhite
    let text = UIColor.flatBlackDark
    let textGray = UIColor.flatBlack
    let background = UIColor.white
    let statusBarStyle = UIStatusBarStyle.default
    let barStyle = UIBarStyle.default
    let keyboardAppearance = UIKeyboardAppearance.light
}

struct DarkTheme: Theme {
    let primary = UIColor.flatBlack
    let primaryDark = UIColor.flatBlackDark
    let secondary = UIColor.flatRed
    let secondaryDark = UIColor.flatRedDark
    let separator = UIColor.flatBlackDark
    let text = UIColor.flatWhiteDark
    let textGray = UIColor.flatWhite
    let background = UIColor.flatBlack
    let statusBarStyle = UIStatusBarStyle.lightContent
    let barStyle = UIBarStyle.black
    let keyboardAppearance = UIKeyboardAppearance.dark
}

let themeService = ThemeService<Theme>(themes: [LightTheme(), DarkTheme()])
