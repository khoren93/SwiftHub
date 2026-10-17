//
//  SceneDelegate.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 10/17/26.
//  Copyright © 2026 Khoren Markosyan. All rights reserved.
//

import UIKit
import Toast_Swift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)
        // Keep the launch screen visible until the initial screen is presented
        window.rootViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateInitialViewController()
        window.makeKeyAndVisible()
        self.window = window

        if Configs.Network.useStaging == false {
            connectedToInternet().skip(1).subscribe(onNext: { [weak self] (connected) in
                var style = ToastManager.shared.style
                style.backgroundColor = connected ? UIColor.Material.green: UIColor.Material.red
                let message = connected ? String(localized: .toastConnectionBackMessage): String(localized: .toastConnectionLostMessage)
                let image = connected ? UIImage(resource: .iconToastSuccess): UIImage(resource: .iconToastWarning)
                if let view = self?.window?.rootViewController?.view {
                    view.makeToast(message, position: .bottom, image: image, style: style)
                }
            }).disposed(by: rx.disposeBag)
        }

        // Show initial screen
        Application.shared.presentInitialScreen(in: window)
    }
}
