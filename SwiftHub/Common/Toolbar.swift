//
//  Toolbar.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 2/9/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit

class Toolbar: UIToolbar {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        isTranslucent = false

        theme.barStyle = themeService.attribute { $0.barStyle }
        theme.barTintColor = themeService.attribute { $0.primaryDark }
        theme.tintColor = themeService.attribute { $0.secondary }

        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseDimensions.tableRowHeight)
        }
    }
}
