//
//  Reachability.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

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

        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                self.reachSubject.onNext(false)
            case .reachable:
                self.reachSubject.onNext(true)
            case .unknown:
                self.reachSubject.onNext(false)
            }
        })
    }
}
