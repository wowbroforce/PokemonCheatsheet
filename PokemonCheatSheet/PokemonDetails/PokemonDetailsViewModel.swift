//
//  PokemonDetailsViewModel.swift
//  PokemonCheatSheet
//
//  Created by Prokhor Kharchenko on 12/29/20.
//

import Foundation
import Domain
import RxSwift
import RxCocoa

final class PokemonDetailsViewModel: ViewModelType {
    private let pokemon: Pokemon
    private let pokemonsUseCase: PokemonsUseCaseType
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    private let router: PokemonDetailsRouter

    init(pokemon: Pokemon, pokemonsUseCase: PokemonsUseCaseType, router: PokemonDetailsRouter) {
        self.pokemon = pokemon
        self.pokemonsUseCase = pokemonsUseCase
        self.router = router
    }
    
    func transform(input: Input) -> Output {
        let pokemon = input.fetch
            .flatMapLatest {
                self.pokemonsUseCase
                    .get(by: self.pokemon.id)
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
        
        let images = pokemon
            .flatMapLatest(loadSprites)
            .startWith([])
        
        let details = Driver.combineLatest(pokemon, images) { pokemon, images in
            PokemonDetailsModel(
                name: pokemon.name.capitalized,
                types: pokemon.types.map { $0.type.name },
                stats: pokemon.stats.map { "\($0.stat.name)  - \($0.baseStat)" },
                images: images
            )
        }
        
        let back = input.back.do(onNext: router.toList)
                
        return Output(
            fetching: activityIndicator.asDriver().debug(" - > activity"),
            details: details,
            errors: errorTracker.asDriver(),
            navigation: back
        )
    }
    
    private func loadSprites(for pokemon: Pokemon) -> Driver<[Image]> {
        let images = pokemon
            .sprites
            .all
            .map { url in
                self.pokemonsUseCase
                    .image(for: url)
                    .trackActivity(self.activityIndicator)
                    .trackError(self.errorTracker)
                    .asDriverOnErrorJustComplete()
            }
            
        return Driver.combineLatest(images)
    }

    struct Input {
        let back: Driver<Void>
        let fetch: Driver<Void>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let details: Driver<PokemonDetailsModel>
        let errors: Driver<Error>
        let navigation: Driver<Void>
    }
}
