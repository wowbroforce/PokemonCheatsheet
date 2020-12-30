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
                self.pokemonsUseCase.all(limit: 2000, offset: nil)
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            
        let viewModels = pokemons
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
        
        let error = errorTracker.asDriver()
        
        let hideError = Driver.merge([
            viewModels.map { _ in true },
            error.map { _ in false }
        ])
        
        return Output(
            fetching: activityIndicator.asDriver(),
            pokemons: viewModels,
            error: error,
            navigation: navigation,
            navigationTitle: "Pokemons",
            hideError: hideError
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
        let navigationTitle: String
        let hideError: Driver<Bool>
    }
    
}
