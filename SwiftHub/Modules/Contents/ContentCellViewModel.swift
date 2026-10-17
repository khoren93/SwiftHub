//
//  ContentCellViewModel.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 11/6/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ContentCellViewModel: DefaultTableViewCellViewModel {

    let content: Content

    init(with content: Content) {
        self.content = content
        super.init()
        title.accept(content.name)
        detail.accept(content.type == .file ? content.size?.sizeFromByte() : nil)
        image.accept(content.type.image()?.template)
    }
}

extension ContentType {
    func image() -> UIImage? {
        switch self {
        case .file: return UIImage(resource: .iconCellFile)
        case .dir: return UIImage(resource: .iconCellDir)
        case .submodule: return UIImage(resource: .iconCellSubmodule)
        case .symlink: return UIImage(resource: .iconCellSubmodule)
        case .unknown: return nil
        }
    }
}
