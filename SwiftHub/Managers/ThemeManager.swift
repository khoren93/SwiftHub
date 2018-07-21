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

let themeService = ThemeService<Theme>(themes: [LightTheme(), DarkTheme()])

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
}

struct LightTheme: Theme {
    let primary = UIColor.white
    let primaryDark = UIColor.flatWhiteDark
    let secondary = UIColor.flatRed
    let secondaryDark = UIColor.flatRedDark
    let separator = UIColor.flatWhite
    let text = UIColor.flatBlack
    let textGray = UIColor.flatBlackDark
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
    let text = UIColor.flatWhite
    let textGray = UIColor.flatWhiteDark
    let background = UIColor.flatBlack
    let statusBarStyle = UIStatusBarStyle.lightContent
    let barStyle = UIBarStyle.black
    let keyboardAppearance = UIKeyboardAppearance.dark
}

public extension Reactive where Base: UIView {

    /// Bindable sink for `backgroundColor` property
    public var backgroundColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.backgroundColor = attr
        }
    }
}

public extension Reactive where Base: UITextField {

    /// Bindable sink for `borderColor` property
    public var borderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.borderColor = attr
        }
    }

    /// Bindable sink for `placeholderColor` property
    public var placeholderColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            if let color = attr {
                view.setPlaceHolderTextColor(color)
            }
        }
    }
}

public extension Reactive where Base: RAMAnimatedTabBarItem {

    /// Bindable sink for `iconColor` property
    public var iconColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.iconColor = attr
            view.deselectAnimation()
        }
    }

    /// Bindable sink for `textColor` property
    public var textColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.textColor = attr
            view.deselectAnimation()
        }
    }
}

public extension Reactive where Base: RAMItemAnimation {

    /// Bindable sink for `iconSelectedColor` property
    public var iconSelectedColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.iconSelectedColor = attr
        }
    }

    /// Bindable sink for `textSelectedColor` property
    public var textSelectedColor: Binder<UIColor> {
        return Binder(self.base) { view, attr in
            view.textSelectedColor = attr
        }
    }
}
