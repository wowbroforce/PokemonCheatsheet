//
//  MockPokemonsUseCase.swift
//  PokemonCheatSheetTests
//
//  Created by Prokhor Kharchenko on 1/8/21.
//

import Foundation
import RxSwift
import Domain

final class MockPokemonsUseCase: PokemonsUseCaseType {
    let allHandler: (Int?, Int?) -> Observable<List<PokemonListItem>>
    let getHandler: (String) -> Observable<Pokemon>
    let imageHandler: (String) -> Observable<Image>
    let nextHandler: (String) -> Observable<List<PokemonListItem>>
    
    init(
        allHandler: @escaping (Int?, Int?) -> Observable<List<PokemonListItem>> = notImplemented(),
        getHandler: @escaping (String) -> Observable<Pokemon> = notImplemented(),
        imageHandler: @escaping (String) -> Observable<Image> = notImplemented(),
        nextHandler: @escaping (String) -> Observable<List<PokemonListItem>> = notImplemented()
    ) {
        self.allHandler = allHandler
        self.getHandler = getHandler
        self.imageHandler = imageHandler
        self.nextHandler = nextHandler
    }
    
    func all(limit: Int?, offset: Int?) -> Observable<List<PokemonListItem>> {
        allHandler(limit, offset)
    }
    
    func get(by name: String) -> Observable<Pokemon> {
        getHandler(name)
    }
    
    func image(url: String) -> Observable<Image> {
        imageHandler(url)
    }
    
    func next(url: String) -> Observable<List<PokemonListItem>> {
        nextHandler(url)
    }
}
