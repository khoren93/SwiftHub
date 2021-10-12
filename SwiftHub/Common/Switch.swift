//
//  Switch.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class Switch: UISwitch {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        self.theme.tintColor = themeService.attribute { $0.secondary }
        self.theme.onTintColor = themeService.attribute { $0.secondary }
    }
}
