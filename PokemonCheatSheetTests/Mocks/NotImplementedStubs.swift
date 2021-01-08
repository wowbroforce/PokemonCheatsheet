//
//  NotImplementedStubs.swift
//  PokemonCheatSheetTests
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import RxSwift

func genericFatal<T>(message: String) -> T {
    fatalError(message)
}

func notImplementedSync<T>() -> (T) -> Void {
    return { _ in
        genericFatal(message: "Not implemented")
    }
}

func notImplemented<T, Result>() -> (T) -> Observable<Result> {
    return { _ -> Observable<Result> in
        return genericFatal(message: "Not implemented")
    }
}

func notImplemented<T1, T2, Result>() -> (T1, T2) -> Observable<Result> {
    return { _, _ -> Observable<Result> in
        return genericFatal(message: "Not implemented")
    }
}
