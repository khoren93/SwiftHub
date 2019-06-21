//
//  SlideImageView.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/3/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import ImageSlideshow

class SlideImageView: ImageSlideshow {

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        contentScaleMode = .scaleAspectFit
        contentMode = .scaleAspectFill
        backgroundColor = UIColor.Material.grey100
        borderWidth = Configs.BaseDimensions.borderWidth
        borderColor = .white
        slideshowInterval = 3
        hero.modifiers = [.arc]
        activityIndicator = DefaultActivityIndicator(style: .white, color: UIColor.secondary())
    }

    func setSources(sources: [URL]) {
        setImageInputs(sources.map({ (url) -> KingfisherSource in
            KingfisherSource(url: url)
        }))
    }
}
