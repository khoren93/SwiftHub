//
//  SegmentedControl.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 6/30/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import HMSegmentedControl

class SegmentedControl: HMSegmentedControl {

    let segmentSelection = BehaviorRelay<Int>(value: 0)

    init() {
        super.init(sectionTitles: [])
        makeUI()
    }

    override init(sectionTitles sectiontitles: [String]) {
        super.init(sectionTitles: sectiontitles)
        makeUI()
    }

    override init(sectionImages: [UIImage], sectionSelectedImages: [UIImage]) {
        super.init(sectionImages: sectionImages, sectionSelectedImages: sectionSelectedImages)
        makeUI()
    }

    override init(sectionImages: [UIImage], sectionSelectedImages: [UIImage], titlesForSections sectionTitles: [String]) {
        super.init(sectionImages: sectionImages, sectionSelectedImages: sectionSelectedImages, titlesForSections: sectionTitles)
        makeUI()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    func makeUI() {
        themeService.typeStream.subscribe(onNext: { [weak self] (themeType) in
            let theme = themeType.associatedObject
            self?.backgroundColor = theme.primary
            self?.selectionIndicatorColor = theme.secondary
            let font = UIFont.systemFont(ofSize: 11)
            self?.titleTextAttributes = [NSAttributedString.Key.font: font,
                                         NSAttributedString.Key.foregroundColor: theme.text]
            self?.selectedTitleTextAttributes = [NSAttributedString.Key.font: font,
                                                 NSAttributedString.Key.foregroundColor: theme.secondary]
            self?.setNeedsDisplay()
        }).disposed(by: rx.disposeBag)

        cornerRadius = Configs.BaseDimensions.cornerRadius
        imagePosition = .aboveText
        selectionStyle = .box
        selectionIndicatorLocation = .bottom
        selectionIndicatorBoxOpacity = 0
        selectionIndicatorHeight = 2.0
        segmentEdgeInset = UIEdgeInsets(inset: self.inset)
        indexChangeBlock = { [weak self] index in
            self?.segmentSelection.accept(Int(index))
        }
        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseDimensions.segmentedControlHeight)
        }
        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}
