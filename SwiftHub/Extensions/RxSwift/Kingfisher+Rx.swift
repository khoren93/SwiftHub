//
//  Kingfisher+Rx.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

extension Reactive where Base: UIImageView {

    public var imageURL: Binder<URL?> {
        return self.imageURL(withPlaceholder: nil)
    }

    public func imageURL(withPlaceholder placeholderImage: UIImage?, options: KingfisherOptionsInfo? = []) -> Binder<URL?> {
        return Binder(self.base, binding: { (imageView, url) in
            imageView.kf.setImage(with: url,
                                  placeholder: placeholderImage,
                                  options: options,
                                  progressBlock: nil,
                                  completionHandler: { (image, error, type, url) in })
        })
    }
}

extension Reactive where Base: UIView {

    public var imageURL: Binder<URL?> {
        return self.imageURL()
    }

    public func imageURL(withOptions options: KingfisherOptionsInfo? = []) -> Binder<URL?> {
        return Binder(self.base, binding: { (view, url) in
            if let url = url {
                KingfisherManager.shared.retrieveImage(with: url, options: options, progressBlock: nil, completionHandler: { (image, error, cache, url) in
                    view.backgroundColor = UIColor.averageColor(fromImage: image)
                })
            }
        })
    }
}
