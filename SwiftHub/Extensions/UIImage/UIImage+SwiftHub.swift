//
//  UIImage+SwiftHub.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import Foundation

extension UIImage {

    func merge(image: UIImage) -> UIImage {
        let size = self.size
        let areaFrame = CGRect(origin: CGPoint(), size: size)
        UIGraphicsBeginImageContext(size)
        self.draw(in: areaFrame)
        image.draw(in: areaFrame)
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }
}
