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

class WebViewController: ViewController {

    let url = BehaviorRelay<URL?>(value: nil)

    lazy var rightBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_web(), style: .done, target: nil, action: nil)
        return view
    }()

    lazy var webView: UIWebView = {
        let view = UIWebView()
        view.delegate = self
        self.contentView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func makeUI() {
        super.makeUI()

        navigationItem.rightBarButtonItem = rightBarButton
    }

    override func bindViewModel() {
        super.bindViewModel()

        rightBarButton.rx.tap.asObservable().subscribe(onNext: { [weak self] () in
            if let url = self?.url.value {
                self?.navigator.show(segue: .safari(url), sender: self, transition: .custom)
            }
        }).disposed(by: rx.disposeBag)
        url.map { $0?.absoluteString }.asObservable().bind(to: navigationItem.rx.title).disposed(by: rx.disposeBag)
    }

    func load(url: URL) {
        self.url.accept(url)
        webView.loadRequest(URLRequest(url: url))
    }
}

extension WebViewController: UIWebViewDelegate {

    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        url.accept(request.url)
        return true
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        startAnimating()
    }

    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopAnimating()
    }

    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        stopAnimating()
    }
}
