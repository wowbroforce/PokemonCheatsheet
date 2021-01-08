//
//  PaginatedFetcher.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 1/7/21.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

final class PaginatedFetcher: Fetcher {
    typealias Element = PokemonListItem
    
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    private let limit: Int
    private let useCase: PokemonsUseCaseType
    private let relay = BehaviorRelay<List<Element>>(value: .empty)
    private var shouldLoadNextPage = false
    
    init(limit: Int, useCase: PokemonsUseCaseType) {
        self.limit = limit
        self.useCase = useCase
    }
    
    func start() -> Driver<Void> {
        useCase
            .all(limit: limit, offset: nil)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .do(onNext: set)
            .mapToVoid()
    }
    
    func next() -> Driver<Void> {
        guard shouldLoadNextPage, let url = relay.value.next else { return .empty() }
        return useCase
            .next(url: url)
            .takeLast(1)
            .trackActivity(activityIndicator)
            .trackError(errorTracker)
            .asDriverOnErrorJustComplete()
            .do(onNext: update)
            .mapToVoid()
    }
    
    func list() -> Driver<List<PokemonListItem>> {
        relay.asDriverOnErrorJustComplete()
    }
    
    func fetching() -> Driver<Bool> {
        activityIndicator
            .asDriver()
            .do(onNext: activityChange)
    }
    
    func errors() -> Driver<Error> {
        errorTracker.asDriver()
    }
    
    private func set(list: List<Element>) {
        relay.accept(list)
    }
    
    private func update(list: List<Element>) {
        let mergedList = relay.value.merged(with: list)
        relay.accept(mergedList)
    }
    
    private func activityChange(fetching: Bool) {
        shouldLoadNextPage = !fetching
    }
}
