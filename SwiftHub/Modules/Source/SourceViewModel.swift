//
//  SourceViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 12/23/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Highlightr
import Moya

class SourceViewModel: ViewModel, ViewModelType {

    struct Input {
        let trigger: Observable<Void>
        let historySelection: Observable<Void>
        let themesSelection: Observable<Void>
        let languagesSelection: Observable<Void>
        let themeSelected: Observable<String>
        let languageSelected: Observable<String>
    }

    struct Output {
        let navigationTitle: Driver<String>
        let themes: Driver<[String]>
        let selectedThemeIndex: Driver<Int?>
        let languages: Driver<[String]>
        let selectedLanguageIndex: Driver<Int?>
        let historySelected: Driver<URL>
        let highlightedCode: Observable<NSAttributedString?>
        let themeBackgroundColor: Observable<UIColor?>
        let hidesThemes: Driver<Bool>
        let hidesLanguages: Driver<Bool>
    }

    let highlightr = Highlightr()
    let content: BehaviorRelay<Content>

    let theme = BehaviorRelay<String>(value: "xcode")
    let language = BehaviorRelay<String?>(value: nil)

    var hidesThemes = true
    var hidesLanguages = true

    init(content: Content, provider: SwiftHubAPI) {
        self.content = BehaviorRelay(value: content)
        highlightr?.setTheme(to: "")
        super.init(provider: provider)
    }

    func transform(input: Input) -> Output {

        let themes = input.trigger.map { self.highlightr?.availableThemes() ?? [] }
        let languages = input.trigger.map { self.highlightr?.supportedLanguages() ?? [] }

        input.themeSelected.bind(to: theme).disposed(by: rx.disposeBag)
        input.languageSelected.bind(to: language).disposed(by: rx.disposeBag)

        let text = input.trigger.flatMapLatest { () -> Observable<String> in
            guard let url = self.content.value.downloadUrl?.url else { return Observable.just("")}
            return self.provider.downloadString(url: url)
                .trackActivity(self.loading)
        }

        let highlightedCode = Observable.combineLatest(text, theme, language)
            .map { (text, theme, language) -> NSAttributedString? in
                self.highlightr?.setTheme(to: theme)
                let highlightedCode = self.highlightr?.highlight(text, as: language, fastRender: true)
                return highlightedCode
        }

        let historySelected = input.historySelection.map { (_) -> URL? in
            return self.content.value.htmlUrl?.replacingOccurrences(of: "https://github.com", with: Configs.Network.githistoryBaseUrl).url
        }.asDriver(onErrorJustReturn: nil).filterNil()

        let hidesThemes = input.themesSelection.map({ () -> Bool in
            self.hidesThemes = !self.hidesThemes
            return self.hidesThemes
        }).asDriverOnErrorJustComplete()

        let hidesLanguages = input.languagesSelection.map({ () -> Bool in
            self.hidesLanguages = !self.hidesLanguages
            return self.hidesLanguages
        }).asDriverOnErrorJustComplete()

        let navigationTitle = content.map({ (content) -> String in
            return content.name ?? ""
        }).asDriver(onErrorJustReturn: "")

        languages.subscribe(onNext: { (languages) in
            if let path = self.content.value.name?.pathExtension {
                if languages.contains(path) {
                    self.language.accept(path)
                }
            }
        }).disposed(by: rx.disposeBag)

        let themesEvent = Observable.combineLatest(themes, self.theme)
        let selectedThemeIndex = themesEvent.map { (themes, theme) -> Int? in
            return themes.firstIndex(of: theme)
        }

        let languagesEvent = Observable.combineLatest(languages, self.language.filterNil())
        let selectedLanguageIndex = languagesEvent.map { (languages, language) -> Int? in
            return languages.firstIndex(of: language)
        }

        let themeBackgroundColor = highlightedCode.map { _ in self.highlightr?.theme.themeBackgroundColor }

        return Output(navigationTitle: navigationTitle,
                      themes: themes.asDriver(onErrorJustReturn: []),
                      selectedThemeIndex: selectedThemeIndex.asDriver(onErrorJustReturn: nil),
                      languages: languages.asDriver(onErrorJustReturn: []),
                      selectedLanguageIndex: selectedLanguageIndex.asDriver(onErrorJustReturn: nil),
                      historySelected: historySelected,
                      highlightedCode: highlightedCode,
                      themeBackgroundColor: themeBackgroundColor,
                      hidesThemes: hidesThemes,
                      hidesLanguages: hidesLanguages)
    }
}
