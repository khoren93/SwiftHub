//
//  LoginViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 7/12/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

enum LoginSegments: Int {
    case basic, oAuth

    var title: String {
        switch self {
        case .basic: return R.string.localizable.loginBasicSegmentTitle.key.localized()
        case .oAuth: return R.string.localizable.loginOAuthSegmentTitle.key.localized()
        }
    }
}

class LoginViewController: ViewController {

    var viewModel: LoginViewModel!

    lazy var segmentedControl: SegmentedControl = {
        let items = [LoginSegments.basic.title, LoginSegments.oAuth.title]
        let view = SegmentedControl(items: items)
        view.selectedSegmentIndex = 0
        return view
    }()

    lazy var basicLoginStackView: StackView = {
        let subviews: [UIView] = [self.basicLogoImageView, self.loginTextField, self.passwordTextField, self.basicLoginButton]
        let view = StackView(arrangedSubviews: subviews)
        return view
    }()

    lazy var oAuthLoginStackView: StackView = {
        let subviews: [UIView] = [self.oAuthLogoImageView, self.titleLabel, self.detailLabel, self.oAuthloginButton]
        let view = StackView(arrangedSubviews: subviews)
        return view
    }()

    lazy var basicLogoImageView: ImageView = {
        let view = ImageView(image: R.image.image_no_result()?.withRenderingMode(.alwaysTemplate))
        return view
    }()

    lazy var loginTextField: TextField = {
        let view = TextField()
        view.textAlignment = .center
        view.keyboardType = .emailAddress
        return view
    }()

    lazy var passwordTextField: TextField = {
        let view = TextField()
        view.textAlignment = .center
        view.isSecureTextEntry = true
        return view
    }()

    lazy var basicLoginButton: Button = {
        let view = Button()
        view.imageForNormal = R.image.icon_button_github()
        view.centerTextAndImage(spacing: inset)
        return view
    }()

    lazy var oAuthLogoImageView: ImageView = {
        let view = ImageView(image: R.image.image_no_result()?.withRenderingMode(.alwaysTemplate))
        return view
    }()

    lazy var titleLabel: Label = {
        let view = Label(style: .style211)
        view.font = view.font.withSize(22)
        view.textAlignment = .center
        return view
    }()

    lazy var detailLabel: Label = {
        let view = Label(style: .style122)
        view.font = view.font.withSize(17)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var oAuthloginButton: Button = {
        let view = Button()
        view.imageForNormal = R.image.icon_button_github()
        view.centerTextAndImage(spacing: inset)
        return view
    }()

    private lazy var scrollView: ScrollView = {
        let view = ScrollView()
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

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.loginTextField.placeholder = R.string.localizable.loginLoginTextFieldPlaceholder.key.localized()
            self?.passwordTextField.placeholder = R.string.localizable.loginPasswordTextFieldPlaceholder.key.localized()
            self?.basicLoginButton.titleForNormal = R.string.localizable.loginBasicLoginButtonTitle.key.localized()
            self?.titleLabel.text = R.string.localizable.loginTitleLabelText.key.localized()
            self?.detailLabel.text = R.string.localizable.loginDetailLabelText.key.localized()
            self?.oAuthloginButton.titleForNormal = R.string.localizable.loginOAuthloginButtonTitle.key.localized()
            self?.segmentedControl.setTitle(LoginSegments.basic.title, forSegmentAt: 0)
            self?.segmentedControl.setTitle(LoginSegments.oAuth.title, forSegmentAt: 1)
            self?.navigationItem.titleView = self?.segmentedControl
        }).disposed(by: rx.disposeBag)

        stackView.removeFromSuperview()
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview().inset(self.inset*2)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        })

        themeService.rx
            .bind({ $0.text }, to: titleLabel.rx.textColor)
            .bind({ $0.textGray }, to: detailLabel.rx.textColor)
            .bind({ $0.text }, to: basicLogoImageView.rx.tintColor)
            .bind({ $0.text }, to: oAuthLogoImageView.rx.tintColor)
            .disposed(by: rx.disposeBag)

        stackView.addArrangedSubview(basicLoginStackView)
        stackView.addArrangedSubview(oAuthLoginStackView)
    }

    override func bindViewModel() {
        super.bindViewModel()

        let segmentSelected = Observable.of(segmentedControl.rx.selectedSegmentIndex.map { LoginSegments(rawValue: $0)! }).merge()
        let input = LoginViewModel.Input(segmentSelection: segmentSelected.asDriverOnErrorJustComplete(),
                                         basicLoginTrigger: basicLoginButton.rx.tap.asDriver(),
                                         oAuthLoginTrigger: oAuthloginButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        viewModel.loading.asDriver().drive(onNext: { [weak self] (isLoading) in
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        output.basicLoginButtonEnabled.drive(basicLoginButton.rx.isEnabled).disposed(by: rx.disposeBag)

        _ = loginTextField.rx.textInput <-> viewModel.login
        _ = passwordTextField.rx.textInput <-> viewModel.password

        output.hidesBasicLoginView.drive(basicLoginStackView.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesOAuthLoginView.drive(oAuthLoginStackView.rx.isHidden).disposed(by: rx.disposeBag)

        viewModel.error.asDriver().drive(onNext: { [weak self] (error) in
            self?.showAlert(title: R.string.localizable.commonError.key.localized(),
                            message: R.string.localizable.loginLoginFailedDescription.key.localized())
        }).disposed(by: rx.disposeBag)
    }
}
