//
//  RxSwift+Extensions.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where Element == Bool {
    func not() -> Observable<Bool> {
        map(!)
    }
}

extension SharedSequenceConvertibleType {
    func mapToVoid() -> SharedSequence<SharingStrategy, Void> {
        map { _ in }
    }
}

extension ObservableType {
    func catchErrorJustComplete() -> Observable<Element> {
        return `catch` { _ in
            .empty()
        }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        asDriver { error in
            .empty()
        }
    }
    
    func mapToVoid() -> Observable<Void> {
        map { _ in }
    }
}

public protocol OptionalType {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

extension Optional: OptionalType {
    public var value: Wrapped? {
        return self
    }
}

public extension ObservableType where Element: OptionalType {
    /**
     Unwraps and filters out `nil` elements.
     - returns: `Observable` of source `Observable`'s elements, with `nil` elements filtered out.
     */
    
    func unwrap() -> Observable<Element.Wrapped> {
        return self.flatMap { element -> Observable<Element.Wrapped> in
            guard let value = element.value else {
                return Observable<Element.Wrapped>.empty()
            }
            return Observable<Element.Wrapped>.just(value)
        }
    }
}
