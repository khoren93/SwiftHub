//
//  Button.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

public class Button: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        theme.backgroundImage(from: themeService.attribute { $0.secondary }, for: .normal)
        theme.backgroundImage(from: themeService.attribute { $0.secondary.withAlphaComponent(0.9) }, for: .selected)
        theme.backgroundImage(from: themeService.attribute { $0.secondary.withAlphaComponent(0.6) }, for: .disabled)

        layer.masksToBounds = true
        titleLabel?.lineBreakMode = .byWordWrapping
        cornerRadius = Configs.BaseDimensions.cornerRadius
//        font = font?.withSize(14)

        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseDimensions.buttonHeight)
        }

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
