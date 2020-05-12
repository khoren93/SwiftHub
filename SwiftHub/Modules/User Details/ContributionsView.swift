//
//  ContributionsView.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 5/12/20.
//  Copyright © 2020 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ContributionsView: View {

    let calendar = BehaviorRelay<ContributionCalendar?>(value: nil)

    override func makeUI() {
        super.makeUI()
        snp.makeConstraints({ (make) in
            make.height.equalTo(10)
        })
        calendar.subscribe(onNext: { [weak self] (calendar) in
            self?.updateUI()
        }).disposed(by: self.rx.disposeBag)
    }

    override func updateUI() {
        super.updateUI()
        guard let calendar = calendar.value else { return }

        let itemSize = frame.width / CGFloat(calendar.weeks?.count ?? 0)
        let calculatedHeight = itemSize * 7
        snp.updateConstraints({ (make) in
            make.height.equalTo(calculatedHeight)
        })
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        guard let calendar = calendar.value else { return }

        // Draw contributions chart
        let itemSize = bounds.width / CGFloat(calendar.weeks?.count ?? 0)
        calendar.weeks?.enumerated().forEach({ (weekIndex, week) in
            week.enumerated().forEach { (dayIndex, day) in
                let color = (UIColor(hexString: day.color ?? "") ?? .clear).cgColor
                ctx.setFillColor(color)
                ctx.setStrokeColor(UIColor.primary().cgColor)
                ctx.setLineWidth(1)

                let size = itemSize
                let rectangle = CGRect(x: CGFloat(weekIndex)*size, y: CGFloat(dayIndex)*size, width: size, height: size)
                ctx.addRect(rectangle)
                ctx.drawPath(using: .fillStroke)
            }
        })
    }
}
