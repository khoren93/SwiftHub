//
//  WebViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/19/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import WebKit

class WebViewController: ViewController {

    let url = BehaviorRelay<URL?>(value: nil)

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_web(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var goBackBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_back(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var goForwardBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_forward(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var stopReloadBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_refresh(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var webView: WKWebView = {
        let view = WKWebView()
        view.navigationDelegate = self
        view.uiDelegate = self
        return view
    }()

    lazy var toolbar: Toolbar = {
        let view = Toolbar()
        view.items = [self.goBackBarButton, self.goForwardBarButton, self.spaceBarButton, self.stopReloadBarButton]
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.rightBarButtonItem = rightBarButton
        stackView.insertArrangedSubview(webView, at: 0)
        stackView.addArrangedSubview(toolbar)
        canOpenFlex = false
    }

    override func bindViewModel() {
        super.bindViewModel()

        rightBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            if let url = self?.url.value {
                self?.navigator.show(segue: .safari(url), sender: self, transition: .custom)
            }
        }).disposed(by: rx.disposeBag)

        url.map { $0?.absoluteString }.asObservable().bind(to: navigationItem.rx.title).disposed(by: rx.disposeBag)

        goBackBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            self?.webView.goBack()
        }).disposed(by: rx.disposeBag)

        goForwardBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            self?.webView.goForward()
        }).disposed(by: rx.disposeBag)

        stopReloadBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            if let webView = self?.webView {
                if webView.isLoading {
                    webView.stopLoading()
                } else {
                    webView.reload()
                }
            }
        }).disposed(by: rx.disposeBag)
    }

    override func updateUI() {
        super.updateUI()
        goBackBarButton.isEnabled = webView.canGoBack
        goForwardBarButton.isEnabled = webView.canGoForward
        stopReloadBarButton.image = webView.isLoading ? R.image.icon_navigation_stop(): R.image.icon_navigation_refresh()
    }

    func load(url: URL) {
        self.url.accept(url)
        webView.load(URLRequest(url: url))
    }
}

extension WebViewController: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.url.accept(webView.url)
        updateUI()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        updateUI()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        updateUI()
    }
}

extension WebViewController: WKUIDelegate {

}
