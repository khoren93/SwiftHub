//
//  LanguagesCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/26/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit

class LanguagesCell: TableViewCell {

    lazy var barView = LanguagesBarView()

    lazy var languagesScrollView: ScrollView = {
        let view = ScrollView()
        view.showsHorizontalScrollIndicator = false
        view.addSubview(self.languagesStackView)
        self.languagesStackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
            make.centerY.equalToSuperview()
        })
        return view
    }()

    lazy var languagesStackView: StackView = {
        let view = StackView()
        view.spacing = 15
        view.axis = .horizontal
        view.alignment = .fill
        return view
    }()

    override func makeUI() {
        super.makeUI()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.addArrangedSubview(barView)
        stackView.addArrangedSubview(languagesScrollView)
    }

    func bind(to viewModel: LanguagesCellViewModel) {
        let languages = viewModel.languages?.languages ?? []
        barView.setLanguages(languages, totalSize: viewModel.languages?.totalSize ?? 0)

        languagesStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        languages.forEach { (repoLanguage) in
            languagesStackView.addArrangedSubview(LanguageView(language: repoLanguage))
        }
    }
}

/// Horizontal bar split into segments proportional to each language's size
class LanguagesBarView: View {

    private var segments: [(view: UIView, fraction: CGFloat)] = []

    override func makeUI() {
        super.makeUI()
        layer.borderWidth = 1
        layer.borderColor = UIColor.primaryDark().cgColor
        snp.makeConstraints { (make) in
            make.height.equalTo(20)
        }
    }

    func setLanguages(_ languages: [RepoLanguage], totalSize: Int) {
        segments.forEach { $0.view.removeFromSuperview() }
        segments = languages.map { (language) in
            let fraction = totalSize > 0 ? CGFloat(language.size) / CGFloat(totalSize) : 0
            let color = UIColor(hexString: language.color ?? "") ?? .lightGray
            let label = Label()
            label.backgroundColor = color
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12)
            label.textColor = color.darken(by: 0.40).brightnessAdjustedColor
            if fraction > 0.1 {
                label.text = String(format: "%.2f%%", fraction * 100)
            }
            addSubview(label)
            return (label, fraction)
        }
        setNeedsLayout()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
        var x: CGFloat = 0
        segments.forEach { (segment) in
            let width = bounds.width * segment.fraction
            segment.view.frame = CGRect(x: x, y: 0, width: width, height: bounds.height)
            x += width
        }
    }
}
