//
//  LoginViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/12/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class LoginViewController: ViewController {

    var viewModel: LoginViewModel!

    lazy var logoImageView: ImageView = {
        let view = ImageView(image: R.image.image_no_result()?.withRenderingMode(.alwaysTemplate))
        return view
    }()

    lazy var titleLabel: Label = {
        let view = Label(style: .style211)
        view.font = view.font.withSize(22)
        view.text = "Welcome to SwiftHub"
        view.textAlignment = .center
        return view
    }()

    lazy var detailLabel: Label = {
        let view = Label(style: .style122)
        view.font = view.font.withSize(17)
        view.numberOfLines = 0
        view.text = "Open source Github iOS client written in RxSwift and MVVM architecture."
        view.textAlignment = .center
        return view
    }()

    lazy var loginButton: Button = {
        let view = Button()
//        view.hero.id = "SaveButton"
        view.titleForNormal = "Sign in with Github"
        view.imageForNormal = R.image.icon_button_github()
        view.centerTextAndImage(spacing: inset)
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
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

        navigationTitle = "Login"
        automaticallyAdjustsLeftBarButtonItem = false
        stackView.removeFromSuperview()
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().inset(self.inset*2)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        })

        themeService.rx
            .bind({ $0.text }, to: titleLabel.rx.textColor)
            .bind({ $0.textGray }, to: detailLabel.rx.textColor)
            .bind({ $0.text }, to: logoImageView.rx.tintColor)
            .disposed(by: rx.disposeBag)

        stackView.spacing = self.inset

        stackView.addArrangedSubview(View(height: self.inset*4))
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(View(height: self.inset*2))
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        stackView.addArrangedSubview(View(height: self.inset*2))
        stackView.addArrangedSubview(loginButton)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let input = LoginViewModel.Input(loginTrigger: loginButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.fetching.drive(onNext: { [weak self] (isLoading) in
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

//        output.updated.drive().disposed(by: rx.disposeBag)

//        output.loginButtonEnabled.drive(loginButton.rx.isEnabled).disposed(by: rx.disposeBag)

        output.error.drive(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }
}
