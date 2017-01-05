//
//  Reachability.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import ReachabilitySwift

private let reachabilityManager = ReachabilityManager()

// An observable that completes when the app gets online (possibly completes immediately).
func connectedToInternetOrStubbing() -> Observable<Bool> {
    let online = reachabilityManager.reach
//    let stubbing = Observable.just(true /*APIKeys.sharedKeys.stubResponses*/)

    return online //.combineLatestOr()
}

private class ReachabilityManager: NSObject {
    let _reach = ReplaySubject<Bool>.create(bufferSize: 1)
    var reach: Observable<Bool> {
        return _reach.asObservable()
    }

    fileprivate let reachability = Reachability.init() // Reachability.forInternetConnection()

    override init() {
        super.init()

        reachability?.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                self._reach.onNext(true)
            }
        }
        reachability?.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                self._reach.onNext(false)
            }
        }

        do {
            try reachability?.startNotifier()
            _reach.onNext(reachability?.isReachable ?? false)

        } catch {
            print("Unable to start notifier")
        }

    }
}
