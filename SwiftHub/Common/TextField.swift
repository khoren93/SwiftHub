//
//  TextField.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    override var placeholder: String? {
        didSet {
            themeService.switch(themeService.type)
        }
    }

    func makeUI() {
        theme.textColor = themeService.attribute { $0.text }
        theme.tintColor = themeService.attribute { $0.secondary }
        theme.placeholderColor = themeService.attribute { $0.textGray }
        theme.borderColor = themeService.attribute { $0.text }
        theme.keyboardAppearance = themeService.attribute { $0.keyboardAppearance }

        layer.masksToBounds = true
        borderWidth = Configs.BaseDimensions.borderWidth
        cornerRadius = Configs.BaseDimensions.cornerRadius

        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseDimensions.textFieldHeight)
        }
    }
}
