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

class ContentCellViewModel {

    let title: Driver<String>
    let detail: Driver<String>
    let image: Driver<UIImage?>

    let content: Content

    init(with content: Content) {
        self.content = content
        title = Driver.just("\(content.name ?? "")")
        detail = Driver.just("\(content.type == .file ? content.size?.size() ?? "" : "")")
        image = Driver.just(content.type.image()?.template)
    }
}

extension ContentType {
    func image() -> UIImage? {
        switch self {
        case .file: return R.image.icon_cell_file()
        case .dir: return R.image.icon_cell_dir()
        case .submodule: return R.image.icon_cell_submodule()
        case .symlink: return R.image.icon_cell_submodule()
        case .unknown: return nil
        }
    }
}
