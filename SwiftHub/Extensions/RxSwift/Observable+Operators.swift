//
//  Observable+Operators.swift
//  Cake Builder
//
//  Created by Khoren Markosyan on 10/19/16.
//  Copyright © 2016 Khoren Markosyan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: UIView {
    func tap() -> Observable<Void> {
        return tapGesture().when(.recognized).mapToVoid()
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

extension Observable where Element: Equatable {
    func ignore(value: Element) -> Observable<Element> {
        return filter { (selfE) -> Bool in
            return value != selfE
        }
    }
}

extension ObservableType where Element == Bool {
    /// Boolean not operator
    public func not() -> Observable<Bool> {
        return self.map(!)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        return map { _ in }
    }
}

extension ObservableType {
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }

    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
}

//https://gist.github.com/brocoo/aaabf12c6c2b13d292f43c971ab91dfa
extension Reactive where Base: UIScrollView {
    public var reachedBottom: Observable<Void> {
        let scrollView = self.base as UIScrollView
        return self.contentOffset.flatMap { [weak scrollView] (contentOffset) -> Observable<Void> in
            guard let scrollView = scrollView else { return Observable.empty() }
            let visibleHeight = scrollView.frame.height - self.base.contentInset.top - scrollView.contentInset.bottom
            let y = contentOffset.y + scrollView.contentInset.top
            let threshold = max(0.0, scrollView.contentSize.height - visibleHeight)
            return (y > threshold) ? Observable.just(()) : Observable.empty()
        }
    }
}

// Two way binding operator between control property and variable, that's all it takes {

infix operator <-> : DefaultPrecedence

func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument

    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }

    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }

    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }

    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

func <-> <Base>(textInput: TextInput<Base>, variable: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: textInput.text)
    let bindToVariable = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] value in
            guard let base = base else {
                return
            }

            let nonMarkedTextValue = nonMarkedText(base)

            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with

             if nonMarkedTextValue != variable.value {
             variable.value = nonMarkedTextValue ?? ""
             }

             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != variable.value {
                variable.accept(nonMarkedTextValue)
            }
            }, onCompleted: {
                bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}

func <-> <T>(property: ControlProperty<T>, variable: BehaviorRelay<T>) -> Disposable {
    if T.self == String.self {
        #if DEBUG
        fatalError("It is ok to delete this message, but this is here to warn that you are maybe trying to bind to some `rx.text` property directly to variable.\n" +
            "That will usually work ok, but for some languages that use IME, that simplistic method could cause unexpected issues because it will return intermediate results while text is being inputed.\n" +
            "REMEDY: Just use `textField <-> variable` instead of `textField.rx.text <-> variable`.\n" +
            "Find out more here: https://github.com/ReactiveX/RxSwift/issues/649\n"
        )
        #endif
    }

    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { value in
            variable.accept(value)
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToVariable)
}
