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

    lazy var emailTextField: TextField = {
        let view = TextField()
        view.placeholder = "email"
        view.textAlignment = .center
        view.keyboardType = .emailAddress
        view.addBottomBorder(leftInset: 0)
        return view
    }()

    lazy var passwordTextField: TextField = {
        let view = TextField()
        view.placeholder = "password"
        view.textAlignment = .center
        view.isSecureTextEntry = true
        view.addBottomBorder(leftInset: 0)
        return view
    }()

    lazy var loginButton: Button = {
        let view = Button()
//        view.hero.id = "SaveButton"
        view.setTitle("Login", for: .normal)
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

        stackView.spacing = self.inset

        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
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

        _ = emailTextField.rx.textInput <-> viewModel.email
        _ = passwordTextField.rx.textInput <-> viewModel.password

        output.error.drive(onNext: { (error) in
            logError("\(error)")
        }).disposed(by: rx.disposeBag)
    }
}
