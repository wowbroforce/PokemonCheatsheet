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
    private let router: PokemonListRouter
    private let fetcher: AnyFetcher<PokemonListItem>
    
    init(
        pokemonsUseCase: PokemonsUseCaseType,
        router: PokemonListRouter,
        fetcher: AnyFetcher<PokemonListItem>
    ) {
        self.pokemonsUseCase = pokemonsUseCase
        self.router = router
        self.fetcher = fetcher
    }
    
    func transform(input: Input) -> Output {
        let start = input.fetch
            .flatMapLatest {
                self.fetcher.start()
            }
        
        let next = input.next
            .flatMapLatest {
                self.fetcher.next()
            }
            
        let viewModels = fetcher.list()
            .map { list in
                list.results.map {
                    PokemonListViewCellViewModel(
                        item: $0,
                        pokemonsUseCase: self.pokemonsUseCase,
                        placeholderImage: Image()
                    )
                }
            }
        
        let navigation = input.selected
            .withLatestFrom(viewModels) { indexPath, pokemons in
                pokemons[indexPath.row].item
            }
            .do(onNext: router.toDetails)
            .mapToVoid()
        
        let error = fetcher.errors()
        
        let hideError = Driver.merge([
            viewModels.map { _ in true },
            error.map { _ in false }
        ])
        
        return Output(
            fetching: fetcher.fetching(),
            pokemons: viewModels,
            error: error,
            navigation: .merge(navigation, start, next),
            navigationTitle: "Pokemons",
            hideError: hideError
        )
    }

    struct Input {
        let fetch: Driver<Void>
        let next: Driver<Void>
        let selected: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let pokemons: Driver<[PokemonListViewCellViewModel]>
        let error: Driver<Error>
        let navigation: Driver<Void>
        let navigationTitle: String
        let hideError: Driver<Bool>
    }
}
