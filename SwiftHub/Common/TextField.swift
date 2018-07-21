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

    func makeUI() {
        themeService.bind([
            ({ $0.text }, [rx.textColor]),
            ({ $0.secondary }, [rx.tintColor]),
            ({ $0.textGray }, [rx.placeholderColor]),
            ({ $0.text }, [rx.borderColor])
        ]).disposed(by: rx.disposeBag)

        layer.masksToBounds = true
        borderWidth = Configs.BaseDimensions.borderWidth
        cornerRadius = Configs.BaseDimensions.cornerRadius
//        font = font?.withSize(14)

        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseDimensions.textFieldHeight)
        }
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
