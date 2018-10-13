//
//  ThemeManager.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/21/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxTheme
import RAMAnimatedTabBarController
import KafkaRefresh

protocol Theme {
    var primary: UIColor { get }
    var primaryDark: UIColor { get }
    var secondary: UIColor { get }
    var secondaryDark: UIColor { get }
    var separator: UIColor { get }
    var text: UIColor { get }
    var textGray: UIColor { get }
    var background: UIColor { get }
    var statusBarStyle: UIStatusBarStyle { get }
    var barStyle: UIBarStyle { get }
    var keyboardAppearance: UIKeyboardAppearance { get }

    init(colorTheme: ColorTheme)
}

struct LightTheme: Theme {
    let primary = UIColor.white
    let primaryDark = UIColor.flatWhite
    var secondary = UIColor.flatRed
    var secondaryDark = UIColor.flatRedDark
    let separator = UIColor.flatWhite
    let text = UIColor.flatBlack
    let textGray = UIColor.flatGray
    let background = UIColor.white
    let statusBarStyle = UIStatusBarStyle.default
    let barStyle = UIBarStyle.default
    let keyboardAppearance = UIKeyboardAppearance.light

    init(colorTheme: ColorTheme) {
        secondary = colorTheme.color
        secondaryDark = colorTheme.colorDark
    }
}

struct DarkTheme: Theme {
    let primary = UIColor.flatBlack
    let primaryDark = UIColor.flatBlackDark
    var secondary = UIColor.flatRed
    var secondaryDark = UIColor.flatRedDark
    let separator = UIColor.flatBlackDark
    let text = UIColor.flatWhite
    let textGray = UIColor.flatGray
    let background = UIColor.flatBlack
    let statusBarStyle = UIStatusBarStyle.lightContent
    let barStyle = UIBarStyle.black
    let keyboardAppearance = UIKeyboardAppearance.dark

    init(colorTheme: ColorTheme) {
        secondary = colorTheme.color
        secondaryDark = colorTheme.colorDark
    }
}

enum ColorTheme: Int {
    case red, green, blue, skyBlue, magenta, purple, watermelon, lime, pink

    static let allValues = [red, green, blue, skyBlue, magenta, purple, watermelon, lime, pink]

    var color: UIColor {
        switch self {
        case .red: return UIColor.flatRed
        case .green: return UIColor.flatGreen
        case .blue: return UIColor.flatBlue
        case .skyBlue: return UIColor.flatSkyBlue
        case .magenta: return UIColor.flatMagenta
        case .purple: return UIColor.flatPurple
        case .watermelon: return UIColor.flatWatermelon
        case .lime: return UIColor.flatLime
        case .pink: return UIColor.flatPink
        }
    }

    var colorDark: UIColor {
        switch self {
        case .red: return UIColor.flatRedDark
        case .green: return UIColor.flatGreenDark
        case .blue: return UIColor.flatBlueDark
        case .skyBlue: return UIColor.flatSkyBlueDark
        case .magenta: return UIColor.flatMagentaDark
        case .purple: return UIColor.flatPurpleDark
        case .watermelon: return UIColor.flatWatermelonDark
        case .lime: return UIColor.flatLimeDark
        case .pink: return UIColor.flatPinkDark
        }
    }

    var title: String {
        switch self {
        case .red: return "Red"
        case .green: return "Green"
        case .blue: return "Blue"
        case .skyBlue: return "Sky Blue"
        case .magenta: return "Magenta"
        case .purple: return "Purple"
        case .watermelon: return "Watermelon"
        case .lime: return "Lime"
        case .pink: return "Pink"
        }
    }
}

enum ThemeType: ThemeProvider {
    case light(color: ColorTheme)
    case dark(color: ColorTheme)

    var associatedObject: Theme {
        switch self {
        case .light(let color): return LightTheme(colorTheme: color)
        case .dark(let color): return DarkTheme(colorTheme: color)
        }
    }

    var isDark: Bool {
        switch self {
        case .dark: return true
        default: return false
        }
    }

    func toggled() -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light(let color): theme = ThemeType.dark(color: color)
        case .dark(let color): theme = ThemeType.light(color: color)
        }
        theme.save()
        return theme
    }

    func withColor(color: ColorTheme) -> ThemeType {
        var theme: ThemeType
        switch self {
        case .light: theme = ThemeType.light(color: color)
        case .dark: theme = ThemeType.dark(color: color)
        }
        theme.save()
        return theme
    }
}

extension ThemeType {
    static func currentTheme() -> ThemeType {
        let defaults = UserDefaults.standard
        let isDark = defaults.bool(forKey: "IsDarkKey")
        let colorTheme = ColorTheme(rawValue: defaults.integer(forKey: "ThemeKey")) ?? ColorTheme.red
        let theme = isDark ? ThemeType.dark(color: colorTheme) : ThemeType.light(color: colorTheme)
        theme.save()
        return theme
    }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(self.isDark, forKey: "IsDarkKey")
        switch self {
        case .light(let color): defaults.set(color.rawValue, forKey: "ThemeKey")
        case .dark(let color): defaults.set(color.rawValue, forKey: "ThemeKey")
        }
    }
}

let themeService = ThemeType.service(initial: ThemeType.currentTheme())

extension Reactive where Base: UIView {

    var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.backgroundColor = attr
        }
    }
}

extension Reactive where Base: UITextField {

    var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.borderColor = attr
        }
    }

    var placeholderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            if let color = attr {
                view.setPlaceHolderTextColor(color)
            }
        }
    }
}

extension Reactive where Base: UITableView {

    var separatorColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.separatorColor = attr
        }
    }
}

extension Reactive where Base: RAMAnimatedTabBarItem {

    var iconColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.iconColor = attr
            view.deselectAnimation()
        }
    }

    var textColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.textColor = attr
            view.deselectAnimation()
        }
    }
}

extension Reactive where Base: RAMItemAnimation {

    var iconSelectedColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.iconSelectedColor = attr
        }
    }

    var textSelectedColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.textSelectedColor = attr
        }
    }
}

extension Reactive where Base: UINavigationBar {

    @available(iOS 11.0, *)
    var largeTitleTextAttributes: Binder<[NSAttributedString.Key: Any]?> {
        return Binder(self.base) { view, attr in
            view.largeTitleTextAttributes = attr
        }
    }
}

extension Reactive where Base: UIApplication {

    var statusBarStyle: Binder<UIStatusBarStyle> {
        return Binder(self.base) { view, attr in
            view.statusBarStyle = attr
        }
    }
}

extension Reactive where Base: KafkaRefreshDefaults {

    var themeColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.themeColor = attr
        }
    }
}

public extension Reactive where Base: UISwitch {

    public var onTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.onTintColor = attr
        }
    }

    public var thumbTintColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.thumbTintColor = attr
        }
    }
}
