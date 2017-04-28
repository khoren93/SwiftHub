//
//  MainViewController.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/6/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import UIKit
import CocoaLumberjackSwift
import Gloss

class MainViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        provider.request(.userRepositories(username: "khoren93"))
            .subscribe(onNext: { (response) in
                do {
                    let itemsJSON = try response.mapJSON() as? [JSON]
                    guard let items = [Repository].from(jsonArray: itemsJSON!) else {
                        DDLogError("Decoding Failure :(")
                        return
                    }
                    DDLogDebug("\(items)")
                } catch {
                    DDLogError("\(error)")
                }
            }, onError: { (error) in
                DDLogError("\(error)")
            }, onCompleted: {
            }, onDisposed: { })
            .disposed(by: rx_disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
