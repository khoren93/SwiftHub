//
//  LinesCountViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 4/16/20.
//  Copyright © 2020 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Charts
import BonMot

class LinesCountViewController: ViewController {

    var totalLines: LanguageLines?

    lazy var chartView: PieChartView = {
        let view = PieChartView()
        view.delegate = self
        view.usePercentValuesEnabled = false
        view.drawSlicesUnderHoleEnabled = true
        view.holeRadiusPercent = 0.58
        view.transparentCircleRadiusPercent = 0.610
        view.chartDescription?.enabled = true
        view.setExtraOffsets(left: self.inset, top: self.inset, right: self.inset, bottom: self.inset)

        view.drawCenterTextEnabled = true
        view.drawHoleEnabled = true
        view.rotationEnabled = false
        view.highlightPerTapEnabled = true
        view.holeColor = UIColor.primaryDark()

        let legend = view.legend
//        l.horizontalAlignment = .right
//        l.verticalAlignment = .top
        legend.orientation = .vertical
        legend.drawInside = false
        legend.textColor = .text()
//        l.xEntrySpace = 7
//        l.yEntrySpace = 0
//        l.yOffset = 0
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        stackView.addArrangedSubview(chartView)
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? LinesCountViewModel else { return }

        let refresh = Observable.of(Observable.just(())).merge()
        let input = LinesCountViewModel.Input(refresh: refresh)
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

        isLoading.subscribe(onNext: { [weak self] (loading) in
            loading ? self?.startAnimating(): self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        output.items.drive(onNext: { [weak self] (items) in
            self?.totalLines = items.filter { $0.language == "Total" }.first
            self?.chartView.centerAttributedText = self?.totalLines?.attributetDetail()

            let languages = items.filter { $0.language != "Total" }
            let languageEntries = languages.map { PieChartDataEntry(value: Double($0.linesOfCode?.int ?? 0), label: $0.language, data: $0) }
            let colors = languages.map { $0.language ?? "" }.map { viewModel.color(for: $0) ?? "" }.map { UIColor(hexString: $0) ?? UIColor.random }
            let languagesDataSet = PieChartDataSet(entries: languageEntries, label: "Type of Files")
            languagesDataSet.colors = colors
            let data = PieChartData(dataSet: languagesDataSet)
            self?.chartView.data = data

            self?.chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        }).disposed(by: rx.disposeBag)
    }
}

extension LinesCountViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let languageEntry = entry.data as? LanguageLines {
            self.chartView.centerAttributedText = languageEntry.attributetDetail()
        }
    }

    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        self.chartView.centerAttributedText = totalLines?.attributetDetail()
    }
}

extension LanguageLines {
    func attributetDetail() -> NSAttributedString? {
        var texts: [NSAttributedString] = []

        let titleStyle = StringStyle(.font(UIFont.boldSystemFont(ofSize: 15)), .color(.text()))
        let valueStyle = StringStyle(.font(UIFont.systemFont(ofSize: 14)), .color(.text()))

        let language = (self.language ?? "").styled(with: titleStyle).styled(with: .underline(.single, .text()))
        let files = (self.files ?? "").styled(with: valueStyle)
        let lines = (self.lines ?? "").styled(with: valueStyle)
        let blanks = (self.blanks ?? "").styled(with: valueStyle)
        let comments = (self.comments ?? "").styled(with: valueStyle)
        let linesOfCode = (self.linesOfCode ?? "").styled(with: valueStyle)

        texts.append(NSAttributedString.composed(of: [
            language, Special.nextLine,
            "Files".styled(with: titleStyle), Special.emSpace, files, Special.nextLine,
            "Blanks".styled(with: titleStyle), Special.emSpace, blanks, Special.nextLine,
            "Comments".styled(with: titleStyle), Special.emSpace, comments, Special.nextLine,
            "Code".styled(with: titleStyle), Special.emSpace, linesOfCode, Special.nextLine,
            "Lines".styled(with: titleStyle), Special.emSpace, lines, Special.nextLine
        ]))

        return NSAttributedString.composed(of: texts)
    }
}
