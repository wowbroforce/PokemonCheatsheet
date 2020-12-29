//
//  PokemonListViewModel.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Domain
import RxCocoa
import RxSwift

final class PokemonListViewModel: ViewModelType {
    private let pokemonsUseCase: PokemonsUseCaseType
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    private let router: PokemonListRouter
    
    init(pokemonsUseCase: PokemonsUseCaseType, router: PokemonListRouter) {
        self.pokemonsUseCase = pokemonsUseCase
        self.router = router
    }
    
    func transform(input: Input) -> Output {
        let pokemons = input.fetch
            .flatMapLatest {
                self.pokemonsUseCase.all(filter: [:])
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            .map { pokemons in
                pokemons.map {
                    PokemonListViewCellViewModel(
                        pokemon: $0,
                        pokemonsUseCase: self.pokemonsUseCase
                    )
                }
            }
        
        let navigation = input.selected
            .withLatestFrom(pokemons) { indexPath, pokemons in
                pokemons[indexPath.row].pokemon
            }
            .do(onNext: router.toDetails)
            .mapToVoid()
        
        return Output(
            fetching: activityIndicator.asDriver(),
            pokemons: pokemons,
            error: errorTracker.asDriver(),
            navigation: navigation
        )
    }

    struct Input {
        let fetch: Driver<Void>
        let selected: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let pokemons: Driver<[PokemonListViewCellViewModel]>
        let error: Driver<Error>
        let navigation: Driver<Void>
    }
    
}
