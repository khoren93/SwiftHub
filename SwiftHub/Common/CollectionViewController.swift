//
//  CollectionViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit

class CollectionViewController: ViewController {

    lazy var collectionView: CollectionView = {
        let view = CollectionView()
        view.emptyDataSetSource = self
        view.emptyDataSetDelegate = self
        return view
    }()

    var clearsSelectionOnViewWillAppear = true

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if clearsSelectionOnViewWillAppear == true {
            deselectSelectedItems()
        }
    }

    override func makeUI() {
        super.makeUI()

        stackView.spacing = 0
        stackView.insertArrangedSubview(collectionView, at: 0)
    }
}

extension CollectionViewController {

    func deselectSelectedItems() {
        if let selectedIndexPaths = collectionView.indexPathsForSelectedItems {
            selectedIndexPaths.forEach({ (indexPath) in
                collectionView.deselectItem(at: indexPath, animated: false)
            })
        }
    }
}
