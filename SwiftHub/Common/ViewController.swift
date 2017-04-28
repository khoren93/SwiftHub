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
import CocoaLumberjackSwift
import NVActivityIndicatorView
import Kingfisher

public class ViewController: UIViewController {

    let inset = Configs.BaseDimensions.Inset

    fileprivate(set) var provider = Networking.newDefaultNetworking()

    let kf = KingfisherManager.shared

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
            .subscribe { [weak self] (event) in
                self?.orientationChanged()
            }
            .disposed(by: rx_disposeBag)

        // Observe application did become active notification
        NotificationCenter.default
            .rx.notification(NSNotification.Name.UIApplicationDidBecomeActive)
            .subscribe { [weak self] (event) in
                self?.didBecomeActive()
            }
            .disposed(by: rx_disposeBag)

        // Two finger swipe gesture for opening Flex
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleTwoFingerQuadrupleSwipe(swipeRecognizer:)))
        swipeGesture.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(swipeGesture)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI()
    }

    deinit {
        DDLogInfo("\(type(of: self)) deinit")
    }

    func makeUI() {
        updateUI()
        navigationItem.backBarButtonItem = backBarButton
    }

    func updateUI() {

    }

    func orientationChanged() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.updateUI()
        }
    }

    func didBecomeActive() {
        self.updateUI()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func closeAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ViewController {

    func handleTwoFingerQuadrupleSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .recognized {
            LibsManager.shared.showFlex()
        }
    }
}
