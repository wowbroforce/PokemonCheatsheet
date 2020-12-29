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
