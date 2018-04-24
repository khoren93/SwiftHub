//
//  View.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

public class View: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        self.layer.masksToBounds = true
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func getCenter() -> CGPoint {
        return convert(center, from: superview)
    }
}

extension UIView {

    var inset: CGFloat {
        return Configs.BaseDimensions.inset
    }

    open func setPriority(_ priority: UILayoutPriority, for axis: UILayoutConstraintAxis) {
        self.setContentHuggingPriority(priority, for: axis)
        self.setContentCompressionResistancePriority(priority, for: axis)
    }
}
