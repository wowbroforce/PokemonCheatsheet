//
//  PokemonListViewModel.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import RxSwift
import RxCocoa
import Domain

final class PokemonListViewModel: ViewModelType {
    struct Input {
        let fetch: Driver<Void>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let pokemons: Driver<[Pokemon]>
        let fetching: Driver<Bool>
        let errors: Driver<Error>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            pokemons: .empty(),
            fetching: .empty(),
            errors: .empty()
        )
    }
}
