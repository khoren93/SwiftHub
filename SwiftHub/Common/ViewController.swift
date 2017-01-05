//
//  ViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import NSObject_Rx

public class ViewController: UIViewController {

    let inset = Configs.BaseDimensions.Inset

    fileprivate(set) var provider = Networking.newStubbingNetworking()

    var backButtonImage = R.image.icon_navigation_back()
    lazy var backBarButton: BarButtonItem = {
        let view = BarButtonItem()
        view.title = ""
        view.tintColor = .secondaryColor()
        return view
    }()

    lazy var closeBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_close(),
                                 style: .plain,
                                 target: self,
                                 action: #selector(closeAction(sender:)))
        return view
    }()

    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        makeUI()

        // Observe device orientation change
        NotificationCenter.default
            .rx.notification(NSNotification.Name.UIDeviceOrientationDidChange)
            .subscribe { (event) in
                self.orientationChanged()
            }
            .addDisposableTo(rx_disposeBag)
    }

    func makeUI() {
        updateUI()
        navigationItem.backBarButtonItem = backBarButton
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationController?.navigationBar.tintColor = .secondaryColor()
    }

    func updateUI() {

    }

    func orientationChanged() {

    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func closeAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
