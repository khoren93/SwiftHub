//
//  SourceViewController.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SourceViewController: ViewController {

    lazy var historyBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_history(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var themesBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_theme(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var languagesBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_language(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var textView: UITextView = {
        let view = UITextView()
        view.autocorrectionType = .no
        view.autocapitalizationType = .none
        return view
    }()

    lazy var languagesPicker: PickerView = {
        let view = PickerView()
        view.isHidden = true
        return view
    }()

    lazy var themesPicker: PickerView = {
        let view = PickerView()
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        let toolbar = Toolbar()
        toolbar.items = [spaceBarButton, themesBarButton, spaceBarButton, languagesBarButton, spaceBarButton, historyBarButton, spaceBarButton]

        stackView.addArrangedSubview(textView)
        stackView.addArrangedSubview(languagesPicker)
        stackView.addArrangedSubview(themesPicker)
        stackView.addArrangedSubview(toolbar)

        bannerView.isHidden = true
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? SourceViewModel else { return }

        let input = SourceViewModel.Input(trigger: Observable.just(()),
                                          historySelection: historyBarButton.rx.tap.asObservable(),
                                          themesSelection: themesBarButton.rx.tap.asObservable(),
                                          languagesSelection: languagesBarButton.rx.tap.asObservable(),
                                          themeSelected: themesPicker.rx.modelSelected(String.self).map { $0.first }.filterNil(),
                                          languageSelected: languagesPicker.rx.modelSelected(String.self).map { $0.first }.filterNil())
        let output = viewModel.transform(input: input)

        viewModel.loading.asObservable().bind(to: isLoading).disposed(by: rx.disposeBag)

        isLoading.subscribe(onNext: { [weak self] (loading) in
            loading ? self?.startAnimating(): self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        output.navigationTitle.drive(onNext: { [weak self] (title) in
            self?.navigationTitle = title
        }).disposed(by: rx.disposeBag)

        output.languages.drive(languagesPicker.rx.items) { _, item, _ in
            let view = Label()
            view.text = item
            view.textAlignment = .center
            themeService.rx
                .bind({ $0.text }, to: view.rx.textColor)
                .disposed(by: self.rx.disposeBag)
            return view
        }.disposed(by: rx.disposeBag)

        output.themes.drive(themesPicker.rx.items) { _, item, _ in
            let view = Label()
            view.text = item
            view.textAlignment = .center
            themeService.rx
                .bind({ $0.text }, to: view.rx.textColor)
                .disposed(by: self.rx.disposeBag)
            return view
            }.disposed(by: rx.disposeBag)

        output.highlightedCode.subscribe(onNext: { [weak self] (text) in
            self?.textView.attributedText = text
        }, onError: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(),
                            message: error.localizedDescription,
                            buttonTitles: nil,
                            highlightedButtonIndex: nil,
                            completion: { (index) in
                                self?.navigator.pop(sender: self)
            })
        }).disposed(by: rx.disposeBag)

        output.themeBackgroundColor.asDriver(onErrorJustReturn: nil).drive(textView.rx.backgroundColor).disposed(by: rx.disposeBag)

        output.hidesThemes.drive(themesPicker.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesLanguages.drive(languagesPicker.rx.isHidden).disposed(by: rx.disposeBag)

        output.selectedThemeIndex.filterNil().drive(onNext: { [weak self] (index) in
            self?.themesPicker.selectRow(index, inComponent: 0, animated: true)
        }).disposed(by: rx.disposeBag)

        output.selectedLanguageIndex.filterNil().drive(onNext: { [weak self] (index) in
            self?.languagesPicker.selectRow(index, inComponent: 0, animated: true)
        }).disposed(by: rx.disposeBag)

        output.historySelected.drive(onNext: { [weak self] (url) in
            self?.navigator.show(segue: .webController(url), sender: self, transition: .modal)
        }).disposed(by: rx.disposeBag)
    }
}
