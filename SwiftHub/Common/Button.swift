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
        setColor(color: .primaryDark())
        self.layer.masksToBounds = true
        self.cornerRadius = Configs.BaseDimensions.cornerRadius
//        font = font?.withSize(14)

        self.snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseDimensions.buttonHeight)
        }

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func setColor(color: UIColor) {
        setBackgroundImage(UIImage(color: color, size: CGSize(width: 1, height: 1)), for: .normal)
        setBackgroundImage(UIImage(color: color.withAlphaComponent(0.9), size: CGSize(width: 1, height: 1)), for: .selected)
        setBackgroundImage(UIImage(color: color.withAlphaComponent(0.6), size: CGSize(width: 1, height: 1)), for: .disabled)
    }
}
