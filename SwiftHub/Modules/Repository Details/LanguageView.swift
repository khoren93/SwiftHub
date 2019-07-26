//
//  LanguageView.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 7/26/19.
//  Copyright © 2019 Khoren Markosyan. All rights reserved.
//

import UIKit

class LanguageView: StackView {

    private lazy var titleLabel: UILabel = {
        let view = Label()
        view.font = view.font.withSize(12)
        view.textColor = UIColor.text()
        return view
    }()

    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 3
        view.layer.masksToBounds = true
        view.snp.makeConstraints({ (make) in
            make.size.equalTo(15)
        })
        return view
    }()

    init(language: RepoLanguage) {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 6

        addArrangedSubview(colorView)
        colorView.backgroundColor = UIColor(hexString: language.color ?? "") ?? .lightGray

        addArrangedSubview(titleLabel)
        titleLabel.text = language.name
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
