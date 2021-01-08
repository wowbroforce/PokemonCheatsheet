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
    private let item: PokemonListItem
    private let pokemonsUseCase: PokemonsUseCaseType
    private let activityIndicator = ActivityIndicator()
    private let errorTracker = ErrorTracker()
    private let router: PokemonDetailsRouter

    init(item: PokemonListItem, pokemonsUseCase: PokemonsUseCaseType, router: PokemonDetailsRouter) {
        self.item = item
        self.pokemonsUseCase = pokemonsUseCase
        self.router = router
    }
    
    func transform(input: Input) -> Output {
        let pokemon = input.fetch
            .flatMapLatest {
                self.pokemonsUseCase
                    .get(by: self.item.name)
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
                weight: pokemon.weight,
                height: pokemon.height,
                types: pokemon.types.map { $0.type.name.capitalized },
                stats: pokemon.stats.map {
                    ("\($0.stat.name.split(separator: "-").joined(separator: " ").capitalized)", "\($0.baseStat)")
                },
                images: images
            )
        }
        
        let items = details.map(detailsToItems)
        
        let title = pokemon
            .map { $0.name }
            .startWith(item.name)
            .map { $0.capitalized }
        
        let back = input.back.do(onNext: router.toList)
                
        let error = errorTracker.asDriver()
        
        let hideError = Driver.merge([
            details.map { _ in true },
            error.map { _ in false }
        ])

        return Output(
            fetching: activityIndicator.asDriver(),
            details: details,
            detailItems: items,
            errors: errorTracker.asDriver(),
            navigation: back,
            title: title,
            hideError: hideError
        )
    }
    
    private func loadSprites(for pokemon: Pokemon) -> Driver<[Image]> {
        let images = pokemon.sprites.all.map {
            pokemonsUseCase.image(url: $0)
                .trackError(errorTracker)
                .trackActivity(activityIndicator)
                .asDriverOnErrorJustComplete()
        }
        return Driver.zip(images)
    }
    
    private func detailsToItems(model: PokemonDetailsModel) -> [PokemonDetailsModelItem] {
        let sprite = model.images.first.flatMap { PokemonDetailsModelItem.sprite($0) }
        let details = PokemonDetailsModelItem.details(
            weight: model.weight,
            height: model.height,
            types: model.types
        )
        let statsHeader = PokemonDetailsModelItem.header("Stats")
        let stats = model.stats.map { PokemonDetailsModelItem.stat(name: $0, value: $1) }
        let galleryHeader = PokemonDetailsModelItem.header("Other Images")
        let gallery = model.images.count > 0 ? PokemonDetailsModelItem.gallery(model.images) : nil
        let items = [sprite, details, statsHeader] + stats + [galleryHeader, gallery]
        return items.compactMap { $0 }
    }

    struct Input {
        let back: Driver<Void>
        let fetch: Driver<Void>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let details: Driver<PokemonDetailsModel>
        let detailItems: Driver<[PokemonDetailsModelItem]>
        let errors: Driver<Error>
        let navigation: Driver<Void>
        let title: Driver<String>
        let hideError: Driver<Bool>
    }
}
