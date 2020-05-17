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

    let imageView = ImageView()

    override func makeUI() {
        super.makeUI()
        addSubview(imageView)
        imageView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(0)
        })
        calendar.asDriver().drive(onNext: { [weak self] (calendar) in
            self?.updateUI()
        }).disposed(by: self.rx.disposeBag)
    }

    override func updateUI() {
        super.updateUI()
        guard let calendar = calendar.value else { return }
        let daySize = frame.width / CGFloat(calendar.weeks?.count ?? 0)
        let calculatedHeight = daySize * 7
        self.imageView.image = contributionsImage(with: calendar, daySize: daySize)
        self.imageView.snp.updateConstraints({ (make) in
            make.height.equalTo(calculatedHeight)
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }

    func contributionsImage(with calendar: ContributionCalendar, daySize: CGFloat) -> UIImage {
        let calculatedWidth = daySize * CGFloat(calendar.weeks?.count ?? 0)
        let calculatedHeight = daySize * 7
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: calculatedWidth, height: calculatedHeight))
        let img = renderer.image { ctx in
            // Draw contributions chart
            calendar.weeks?.enumerated().forEach({ (weekIndex, week) in
                week.enumerated().forEach { (dayIndex, day) in
                    let color = (UIColor(hexString: day.color ?? "") ?? .clear).cgColor
                    ctx.cgContext.setFillColor(color)
                    ctx.cgContext.setStrokeColor(UIColor.primary().cgColor)
                    ctx.cgContext.setLineWidth(1)
                    ctx.cgContext.addRect(CGRect(x: CGFloat(weekIndex)*daySize, y: CGFloat(dayIndex)*daySize, width: daySize, height: daySize))
                    ctx.cgContext.drawPath(using: .fillStroke)
                }
            })
        }
        return img
    }
}
