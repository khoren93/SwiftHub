//
//  PickerView.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/26/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class PickerView: UIPickerView {

    init () {
        super.init(frame: CGRect())
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
    }
}
