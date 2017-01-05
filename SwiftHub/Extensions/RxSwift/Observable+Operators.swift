//
//  Observable+Operators.swift
//  SwiftHub
//
//  Created by Khoren Markosyan on 1/4/17.
//  Copyright © 2017 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift

extension Observable where Element: Equatable {
    func ignore(value: Element) -> Observable<Element> {
        return filter { (e) -> Bool in
            return value != e
        }
    }
}

extension Observable {
    // OK, so the idea is that I have a Variable that exposes an Observable and I want
    // to switch to the latest without mapping.
    //
    // viewModel.flatMap { saleArtworkViewModel in return saleArtworkViewModel.lotNumber }
    //
    // Becomes...
    //
    // viewModel.flatMapTo(SaleArtworkViewModel.lotNumber)
    //
    // Still not sure if this is a good idea.

    func flatMapTo<R>(_ selector: @escaping (Element) -> () -> Observable<R>) -> Observable<R> {
        return self.map { (s) -> Observable<R> in
            return selector(s)()
            }.switchLatest()
    }
}

protocol OptionalType {
    associatedtype Wrapped

    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    var value: Wrapped? {
        return self
    }
}

extension Observable where Element: OptionalType {
    func filterNil() -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .empty()
            }
        }
    }

    func filterNilKeepOptional() -> Observable<Element> {
        return self.filter { (element) -> Bool in
            return element.value != nil
        }
    }

    func replaceNil(with nilValue: Element.Wrapped) -> Observable<Element.Wrapped> {
        return flatMap { (element) -> Observable<Element.Wrapped> in
            if let value = element.value {
                return .just(value)
            } else {
                return .just(nilValue)
            }
        }
    }
}

protocol BooleanType {
    var boolValue: Bool { get }
}
extension Bool: BooleanType {
    var boolValue: Bool { return self }
}

// Maps true to false and vice versa
extension Observable where Element: BooleanType {
    func not() -> Observable<Bool> {
        return self.map { input in
            return !input.boolValue
        }
    }
}

extension ObservableType {

    func then(_ closure: @escaping () -> Observable<E>?) -> Observable<E> {
        return then(closure() ?? .empty())
    }

    func then( _ closure: @autoclosure @escaping () -> Observable<E>) -> Observable<E> {
        let next = Observable.deferred {
            return closure()
        }

        return self
            .ignoreElements()
            .concat(next)
    }
}

extension Observable {
    func mapToOptional() -> Observable<Optional<Element>> {
        return map { Optional($0) }
    }
}

func sendDispatchCompleted<T>(to observer: AnyObserver<T>) {
    DispatchQueue.main.async {
        observer.onCompleted()
    }
}
