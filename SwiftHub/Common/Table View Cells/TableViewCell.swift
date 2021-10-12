//
//  TableViewCell.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TableViewCell: UITableViewCell {

    var cellDisposeBag = DisposeBag()

    var isSelection = false
    var selectionColor: UIColor? {
        didSet {
            setSelected(isSelected, animated: true)
        }
    }

    lazy var containerView: View = {
        let view = View()
        view.backgroundColor = .clear
        view.cornerRadius = Configs.BaseDimensions.cornerRadius
        self.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset, vertical: self.inset/2))
        })
        return view
    }()

    lazy var stackView: StackView = {
        let subviews: [UIView] = []
        let view = StackView(arrangedSubviews: subviews)
        view.axis = .horizontal
        view.alignment = .center
        self.containerView.addSubview(view)
        view.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview().inset(inset/2)
        })
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        backgroundColor = selected ? selectionColor : .clear
    }

    func makeUI() {
        layer.masksToBounds = true
        selectionStyle = .none
        backgroundColor = .clear

        theme.selectionColor = themeService.attribute { $0.primary }
        containerView.theme.backgroundColor = themeService.attribute { $0.primary }

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }

    func bind(to viewModel: TableViewCellViewModel) {

    }
}
