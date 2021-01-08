//
//  PaginatedFetcherTests.swift
//  PokemonCheatSheetTests
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import XCTest
import RxSwift
import RxCocoa
import RxTest
import RxBlocking
import Domain
@testable import PokemonCheatSheet

class PaginatedFetcherTests: XCTestCase {
    func testFetcherDoesNotCallSecondNextIfFirstNextCallInProgress() {
        let scheduler = TestScheduler(initialClock: 0)
        let startList = Observable<List<PokemonListItem>>.just(.load(from: "pokemon?limit=10&offset=0")).delay(.seconds(50), scheduler: scheduler)
        let nextList = Observable<List<PokemonListItem>>.just(.load(from: "pokemon?limit=10&offset=10")).delay(.seconds(200), scheduler: scheduler)
        let useCase = MockPokemonsUseCase { (_, _) in startList }
            nextHandler: { _ in nextList }
        
        let fetcher = PaginatedFetcher(limit: 10, useCase: useCase)
        let results = scheduler.createObserver(List<PokemonListItem>.self)
        let bag = DisposeBag()

        scheduler.scheduleAt(100) { fetcher.list().drive(results).disposed(by: bag) }
        scheduler.scheduleAt(200) { fetcher.fetching().drive().disposed(by: bag) }
        scheduler.scheduleAt(300) { fetcher.start().drive().disposed(by: bag) }
        scheduler.scheduleAt(400) { fetcher.next().drive().disposed(by: bag) }
        scheduler.scheduleAt(500) { fetcher.next().drive().disposed(by: bag) }

        scheduler.start()
        
        XCTAssertEqual(results.events.count, 3)
        XCTAssertEqual(results.events[0].value.element?.results.count, 0)
        XCTAssertEqual(results.events[1].value.element?.results.count, 10)
        XCTAssertEqual(results.events[2].value.element?.results.count, 20)
    }
    
    func testFetcherSendsAnErrorIfStartRequestFails() {
        let scheduler = TestScheduler(initialClock: 0)
        let useCase = MockPokemonsUseCase { _, _ in .error(Errors.startFailed) }
        let fetcher = PaginatedFetcher(limit: 10, useCase: useCase)
        let errors = scheduler.createObserver(Error.self)
        let bag = DisposeBag()
        
        scheduler.scheduleAt(100) { fetcher.errors().drive(errors).disposed(by: bag) }
        scheduler.scheduleAt(200) { fetcher.fetching().drive().disposed(by: bag) }
        scheduler.scheduleAt(300) { fetcher.start().drive().disposed(by: bag) }

        scheduler.start()
        
        XCTAssertEqual(errors.events.count, 1)
        XCTAssertEqual(errors.events[0].value.element as? Errors, Errors.startFailed)
    }
    
    func testFetcherSendsAnErrorIfNextRequestFails() {
        let scheduler = TestScheduler(initialClock: 0)
        let startList = Observable<List<PokemonListItem>>.just(.load(from: "pokemon?limit=10&offset=0")).delay(.seconds(50), scheduler: scheduler)
        let useCase = MockPokemonsUseCase { _, _ in startList }
            nextHandler: { _ in .error(Errors.nextFailed) }

        let fetcher = PaginatedFetcher(limit: 10, useCase: useCase)
        let errors = scheduler.createObserver(Error.self)
        let bag = DisposeBag()
        
        scheduler.scheduleAt(100) { fetcher.errors().drive(errors).disposed(by: bag) }
        scheduler.scheduleAt(200) { fetcher.fetching().drive().disposed(by: bag) }
        scheduler.scheduleAt(300) { fetcher.start().drive().disposed(by: bag) }
        scheduler.scheduleAt(400) { fetcher.next().drive().disposed(by: bag) }

        scheduler.start()
        
        XCTAssertEqual(errors.events.count, 1)
        XCTAssertEqual(errors.events[0].value.element as? Errors, Errors.nextFailed)
    }
    
    enum Errors: Error {
        case startFailed, nextFailed
    }
}
