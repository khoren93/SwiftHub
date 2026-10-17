//
//  EmptyDataSetView.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 10/18/26.
//  Copyright © 2026 Khoren Markosyan. All rights reserved.
//

import UIKit

/// Placeholder shown as the background of a list that has no rows
class EmptyDataSetView: View {

    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .center
        return view
    }()

    lazy var titleLabel: Label = {
        let view = Label()
        view.font = UIFont.systemFont(ofSize: 18)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    lazy var stackView: StackView = {
        let view = StackView(arrangedSubviews: [self.imageView, self.titleLabel])
        view.alignment = .center
        view.spacing = self.inset * 2
        return view
    }()

    override func makeUI() {
        super.makeUI()
        isHidden = true
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-60)
            make.left.right.equalToSuperview().inset(self.inset * 4)
        }
        titleLabel.theme.textColor = themeService.attribute { $0.textGray }
    }

    func configure(title: String, image: UIImage?, imageTintColor: UIColor?) {
        titleLabel.text = title
        titleLabel.isHidden = title.isEmpty
        imageView.image = image?.withRenderingMode(imageTintColor == nil ? .alwaysOriginal : .alwaysTemplate)
        imageView.tintColor = imageTintColor
        imageView.isHidden = image == nil
    }
}
