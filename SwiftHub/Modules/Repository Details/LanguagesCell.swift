//
//  LanguagesCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/26/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit
import MultiProgressView

class LanguagesCell: TableViewCell {

    var totalCount = 0
    var totalSize = 0
    var languages: [RepoLanguage] = []

    lazy var progressView: MultiProgressView = {
        let view = MultiProgressView()
        view.dataSource = self
        view.lineCap = .round
        view.trackBorderWidth = 1
        view.trackBorderColor = UIColor.primaryDark()
        view.snp.makeConstraints({ (make) in
            make.height.equalTo(20)
        })
        return view
    }()

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
        stackView.addArrangedSubview(progressView)
        stackView.addArrangedSubview(languagesScrollView)
    }

    func bind(to viewModel: LanguagesCellViewModel) {
        totalCount = viewModel.languages?.totalCount ?? 0
        totalSize = viewModel.languages?.totalSize ?? 0
        languages = viewModel.languages?.languages ?? []
        progressView.reloadData()

        clearLanguagesStackView()
        createLanguagesStackView()
        createProgressView()
    }

    func clearLanguagesStackView() {
        languagesStackView.arrangedSubviews.forEach { (view) in
            view.removeFromSuperview()
        }
        languagesStackView.removeArrangedSubviews()
    }

    func createLanguagesStackView() {
        languages.forEach { (repoLanguage) in
            languagesStackView.addArrangedSubview(LanguageView(language: repoLanguage))
        }
    }

    func createProgressView() {
        for (section, repoLanguage) in languages.enumerated() {
            let progress = percentage(for: repoLanguage) / 100
            progressView.setProgress(section: section, to: progress)
        }
    }

    func percentage(for language: RepoLanguage) -> Float {
        return Float(language.size) / Float(totalSize) * 100
    }
}

extension LanguagesCell: MultiProgressViewDataSource {
    func numberOfSections(in progressView: MultiProgressView) -> Int {
        return languages.count
    }

    func progressView(_ progressView: MultiProgressView, viewForSection section: Int) -> ProgressViewSection {
        let view = ProgressViewSection()
        let repoLanguage = languages[section]
        let percent = percentage(for: repoLanguage)
        let color = UIColor(hexString: repoLanguage.color ?? "") ?? .lightGray
        if percent > 10 {
            view.setAttributedTitle(attributedDetail(for: percent, color: color))
        }
        view.backgroundColor = color
        return view
    }

    func attributedDetail(for percent: Float, color: UIColor) -> NSAttributedString {
        var texts: [NSAttributedString] = []
        let percentString = String(format: "%.2f%%", percent).styled(with: .color(color.darken(by: 0.40).brightnessAdjustedColor),
                                             .backgroundColor(color),
                                             .font(UIFont.systemFont(ofSize: 12)),
                                             .lineHeightMultiple(1.2),
                                             .baselineOffset(1))
        texts.append(NSAttributedString.composed(of: [percentString]))
        return NSAttributedString.composed(of: texts)
    }
}
