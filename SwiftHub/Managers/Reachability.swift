//
//  Reachability.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import Reachability

// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternet() -> Observable<Bool> {
    return ReachabilityManager.shared.reach
}

private class ReachabilityManager: NSObject {

    static let shared = ReachabilityManager()

    let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return reachSubject.asObservable()
    }

    override init() {
        super.init()
        do {
            let reachability = try Reachability()

            reachability.whenReachable = { reachability in
                DispatchQueue.main.async {
                    self.reachSubject.onNext(true)
                }
            }

            reachability.whenUnreachable = { reachability in
                DispatchQueue.main.async {
                    self.reachSubject.onNext(false)
                }
            }

            do {
                try reachability.startNotifier()
                reachSubject.onNext(reachability.connection != Reachability.Connection.unavailable)
            } catch {
                print("Unable to start notifier")
            }
        } catch {
            logError(error.localizedDescription)
        }
    }
}
