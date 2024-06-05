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
    case oAuth, personal, basic

    var title: String {
        switch self {
        case .oAuth: return R.string.localizable.loginOAuthSegmentTitle.key.localized()
        case .personal: return R.string.localizable.loginPersonalSegmentTitle.key.localized()
        case .basic: return R.string.localizable.loginBasicSegmentTitle.key.localized()
        }
    }
}

class LoginViewController: ViewController {

    lazy var segmentedControl: SegmentedControl = {
        let view = SegmentedControl(sectionTitles: [])
        view.selectedSegmentIndex = 0
        view.snp.makeConstraints({ (make) in
            make.width.equalTo(300)
        })
        return view
    }()

    // MARK: - Basic authentication

    lazy var basicLoginStackView: StackView = {
        let subviews: [UIView] = [basicLogoImageView, loginTextField, passwordTextField, basicLoginButton]
        let view = StackView(arrangedSubviews: subviews)
        view.spacing = inset * 2
        return view
    }()

    lazy var basicLogoImageView: ImageView = {
        let view = ImageView(image: R.image.image_no_result()?.template)
        return view
    }()

    lazy var loginTextField: TextField = {
        let view = TextField()
        view.textAlignment = .center
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
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

    // MARK: - OAuth authentication

    lazy var oAuthLoginStackView: StackView = {
        let subviews: [UIView] = [oAuthLogoImageView, titleLabel, detailLabel, oAuthLoginButton]
        let view = StackView(arrangedSubviews: subviews)
        view.spacing = inset * 2
        return view
    }()

    lazy var oAuthLogoImageView: ImageView = {
        let view = ImageView(image: R.image.image_no_result()?.template)
        return view
    }()

    lazy var titleLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(22)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var detailLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(17)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var oAuthLoginButton: Button = {
        let view = Button()
        view.imageForNormal = R.image.icon_button_github()
        view.centerTextAndImage(spacing: inset)
        return view
    }()

    // MARK: - Personal Access Token authentication

    lazy var personalLoginStackView: StackView = {
        let subviews: [UIView] = [personalLogoImageView, personalTitleLabel, personalDetailLabel, personalTokenTextField, personalLoginButton]
        let view = StackView(arrangedSubviews: subviews)
        view.spacing = inset * 2
        return view
    }()

    lazy var personalLogoImageView: ImageView = {
        let view = ImageView(image: R.image.image_no_result()?.template)
        return view
    }()

    lazy var personalTitleLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(22)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var personalDetailLabel: Label = {
        let view = Label()
        view.font = view.font.withSize(17)
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var personalTokenTextField: TextField = {
        let view = TextField()
        view.textAlignment = .center
        view.keyboardType = .emailAddress
        view.autocapitalizationType = .none
        return view
    }()

    lazy var personalLoginButton: Button = {
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

    override func makeUI() {
        super.makeUI()

        navigationItem.titleView = segmentedControl

        languageChanged.subscribe(onNext: { [weak self] () in
            self?.segmentedControl.sectionTitles = [LoginSegments.oAuth.title, LoginSegments.personal.title, LoginSegments.basic.title]
            // MARK: Basic
            self?.loginTextField.placeholder = R.string.localizable.loginLoginTextFieldPlaceholder.key.localized()
            self?.passwordTextField.placeholder = R.string.localizable.loginPasswordTextFieldPlaceholder.key.localized()
            self?.basicLoginButton.titleForNormal = R.string.localizable.loginBasicLoginButtonTitle.key.localized()
            // MARK: Personal
            self?.personalTitleLabel.text = R.string.localizable.loginPersonalTitleLabelText.key.localized()
            self?.personalDetailLabel.text = R.string.localizable.loginPersonalDetailLabelText.key.localizedFormat(Configs.App.githubScope)
            self?.personalTokenTextField.placeholder = R.string.localizable.loginPersonalTokenTextFieldPlaceholder.key.localized()
            self?.personalLoginButton.titleForNormal = R.string.localizable.loginPersonalLoginButtonTitle.key.localized()
            // MARK: OAuth
            self?.titleLabel.text = R.string.localizable.loginTitleLabelText.key.localized()
            self?.detailLabel.text = R.string.localizable.loginDetailLabelText.key.localized()
            self?.oAuthLoginButton.titleForNormal = R.string.localizable.loginOAuthloginButtonTitle.key.localized()
        }).disposed(by: rx.disposeBag)

        stackView.removeFromSuperview()
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(self.inset*2)
            make.centerX.equalToSuperview()
        })

        titleLabel.theme.textColor = themeService.attribute { $0.text }
        personalTitleLabel.theme.textColor = themeService.attribute { $0.text }
        detailLabel.theme.textColor = themeService.attribute { $0.textGray }
        personalDetailLabel.theme.textColor = themeService.attribute { $0.textGray }
        basicLogoImageView.theme.tintColor = themeService.attribute { $0.text }
        personalLogoImageView.theme.tintColor = themeService.attribute { $0.text }
        oAuthLogoImageView.theme.tintColor = themeService.attribute { $0.text }

        stackView.addArrangedSubview(basicLoginStackView)
        stackView.addArrangedSubview(personalLoginStackView)
        stackView.addArrangedSubview(oAuthLoginStackView)
        bannerView.isHidden = true
    }

    override func bindViewModel() {
        super.bindViewModel()
        guard let viewModel = viewModel as? LoginViewModel else { return }

        let segmentSelected = Observable.of(segmentedControl.segmentSelection.map { LoginSegments(rawValue: $0)! }).merge()
        let input = LoginViewModel.Input(segmentSelection: segmentSelected.asDriverOnErrorJustComplete(),
                                         basicLoginTrigger: basicLoginButton.rx.tap.asDriver(),
                                         personalLoginTrigger: personalLoginButton.rx.tap.asDriver(),
                                         oAuthLoginTrigger: oAuthLoginButton.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        isLoading.asDriver().drive(onNext: { [weak self] (isLoading) in
            isLoading ? self?.startAnimating() : self?.stopAnimating()
        }).disposed(by: rx.disposeBag)

        output.basicLoginButtonEnabled.drive(basicLoginButton.rx.isEnabled).disposed(by: rx.disposeBag)
        output.personalLoginButtonEnabled.drive(personalLoginButton.rx.isEnabled).disposed(by: rx.disposeBag)

        _ = loginTextField.rx.textInput <-> viewModel.login
        _ = passwordTextField.rx.textInput <-> viewModel.password
        _ = personalTokenTextField.rx.textInput <-> viewModel.personalToken

        output.hidesBasicLoginView.drive(basicLoginStackView.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesPersonalLoginView.drive(personalLoginStackView.rx.isHidden).disposed(by: rx.disposeBag)
        output.hidesOAuthLoginView.drive(oAuthLoginStackView.rx.isHidden).disposed(by: rx.disposeBag)

        error.subscribe(onNext: { [weak self] (error) in
            self?.view.makeToast(error.description, title: error.title, image: R.image.icon_toast_warning())
        }).disposed(by: rx.disposeBag)
    }
}
