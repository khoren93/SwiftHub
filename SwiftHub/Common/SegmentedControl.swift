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

class SegmentedControl: UISegmentedControl {

    let segmentSelection = BehaviorRelay<Int>(value: 0)

    /// Replaces all segments, keeping the current selection
    var sectionTitles: [String] {
        get { (0..<numberOfSegments).map { titleForSegment(at: $0) ?? "" } }
        set {
            let selected = selectedSegmentIndex >= 0 ? selectedSegmentIndex : segmentSelection.value
            removeAllSegments()
            newValue.enumerated().forEach { insertSegment(withTitle: $1, at: $0, animated: false) }
            if selected < numberOfSegments {
                selectedSegmentIndex = selected
            }
        }
    }

    init(sectionTitles: [String]) {
        super.init(items: sectionTitles)
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
            let font = UIFont.systemFont(ofSize: 13)
            self?.backgroundColor = theme.primary
            self?.selectedSegmentTintColor = theme.primaryDark
            self?.setTitleTextAttributes([.font: font, .foregroundColor: theme.text], for: .normal)
            self?.setTitleTextAttributes([.font: font, .foregroundColor: theme.secondary], for: .selected)
        }).disposed(by: rx.disposeBag)

        rx.selectedSegmentIndex.changed
            .bind(to: segmentSelection)
            .disposed(by: rx.disposeBag)

        snp.makeConstraints { (make) in
            make.height.equalTo(Configs.BaseDimensions.segmentedControlHeight)
        }
    }
}
