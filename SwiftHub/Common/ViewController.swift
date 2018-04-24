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
import Kingfisher
import DZNEmptyDataSet

class ViewController: UIViewController, Navigatable {

    var navigator: Navigator!

    let isLoading = BehaviorRelay(value: false)

    var backButtonImage = R.image.icon_navigation_back()
    lazy var backBarButton: BarButtonItem = {
        let view = BarButtonItem()
        view.title = ""
        view.tintColor = .secondary()
        return view
    }()

    lazy var closeBarButton: BarButtonItem = {
        let view = BarButtonItem(image: R.image.icon_navigation_close(),
                                 style: .plain,
                                 target: self,
                                 action: nil)
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
            }.disposed(by: rx.disposeBag)

        // Observe application did become active notification
        NotificationCenter.default
            .rx.notification(NSNotification.Name.UIApplicationDidBecomeActive)
            .subscribe { [weak self] (event) in
                self?.didBecomeActive()
            }.disposed(by: rx.disposeBag)

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
        //DDLogInfo("\(type(of: self)) deinit")
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

    // MARK: Adjusting Navigation Item

    func adjustLeftBarButtonItem() {
        if self.navigationController?.viewControllers.count ?? 0 > 1 { // pushed
            self.navigationItem.leftBarButtonItem = nil
        } else if self.presentingViewController != nil { // presented
            self.navigationItem.leftBarButtonItem = closeBarButton
        }
    }
}

extension ViewController {

    var inset: CGFloat {
        return Configs.BaseDimensions.inset
    }

    func emptyView(withHeight height: CGFloat) -> View {
        let view = View()
        view.snp.makeConstraints { (make) in
            make.height.equalTo(height)
        }
        return view
    }

    @objc func handleTwoFingerQuadrupleSwipe(swipeRecognizer: UISwipeGestureRecognizer) {
        if swipeRecognizer.state == .recognized {
            LibsManager.shared.showFlex()
        }
    }
}

extension ViewController: DZNEmptyDataSetSource {

    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        return NSAttributedString(string: "No Data")
    }

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
    }

    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return .white
    }

    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
}

extension ViewController: DZNEmptyDataSetDelegate {

    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return !isLoading.value
    }

    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
