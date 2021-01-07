//
//  AnyFetcher.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/7/21.
//

import Foundation
import RxSwift
import RxCocoa
import Domain

final class AnyFetcher<Element: Codable>: Fetcher {
    private let startHandler: () -> Driver<Void>
    private let nextHandler: () -> Driver<Void>
    private let listHandler: () -> Driver<List<Element>>
    private let fetchingHandler: () -> Driver<Bool>
    private let errorsHandler: () -> Driver<Error>
    
    init<T: Fetcher>(fetcher: T) where T.Element == Element {
        startHandler = fetcher.start
        nextHandler = fetcher.next
        listHandler = fetcher.list
        fetchingHandler = fetcher.fetching
        errorsHandler = fetcher.errors
    }

    func start() -> Driver<Void> {
        startHandler()
    }
    
    func next() -> Driver<Void> {
        nextHandler()
    }
    
    func list() -> Driver<List<Element>> {
        listHandler()
    }
    
    func fetching() -> Driver<Bool> {
        fetchingHandler()
    }
    
    func errors() -> Driver<Error> {
        errorsHandler()
    }
}

extension Fetcher {
    func toAny() -> AnyFetcher<Element> {
        AnyFetcher(fetcher: self)
    }
}
