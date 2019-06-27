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
            make.edges.equalToSuperview().inset(UIEdgeInsets(horizontal: self.inset*2, vertical: self.inset))
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
            make.edges.equalToSuperview().inset(inset)
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

        themeService.rx
            .bind({ $0.primary }, to: rx.selectionColor)
            .bind({ $0.primary }, to: containerView.rx.backgroundColor)
            .disposed(by: rx.disposeBag)

        updateUI()
    }

    func updateUI() {
        setNeedsDisplay()
    }
}

extension Reactive where Base: TableViewCell {

    var selectionColor: Binder<UIColor?> {
        return Binder(self.base) { view, attr in
            view.selectionColor = attr
        }
    }
}
